//
//  CameraManager.swift
//  VeganVision
//
//  Created by Ben Gabay on 8/21/22.
//

import Foundation
import AVFoundation

enum CameraError: Error {
    case deniedAuth
    case restrictedAuth
    case unknownAuthorization
    case cameraUnavailable
    case cannotAddInput
    case createCaptureInput(error: Error)
}

enum CameraStatus {
    case unconfigured
    case authorized
    case unauthorized
    case failed
}

class CameraManager {

    static let shared: CameraManager = CameraManager()
    
    var error: CameraError?
    
    // Camera
    let session = AVCaptureSession()
    
    private var status: CameraStatus = .unconfigured

    
    
    private init() {
        configure()
    }
    
    private func configure() {
        checkPermissions()
    }
    
    private func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                if !authorized {
                    self.status = .unauthorized
                    self.set(error: .deniedAuth)
                }
            }
        case .restricted:
            status = .unauthorized
            set(error: .restrictedAuth)
        case .denied:
            status = .unauthorized
            set(error: .deniedAuth)
        case .authorized:
            break
        @unknown default:
            status = .unauthorized
            set(error: .unknownAuthorization)
        }
    }
    
    private func set(error: CameraError?) {
        DispatchQueue.main.async {
            self.error = error
        }
    }
    
    private func configureCaptureSession() {
        guard status == .unconfigured else {
            return
        }
        
        session.beginConfiguration()
        defer {
            session.commitConfiguration()
        }
        
        let device = AVCaptureDevice.default(for: .video)
        guard let camera = device else {
            set(error: .cameraUnavailable)
            status = .failed
            return
        }
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            
            if session.canAddInput(cameraInput) {
                session.addInput(cameraInput)
            } else {
                set(error: .cannotAddInput)
                status = .failed
            }
        } catch {
            set(error: .createCaptureInput(error: error))
            status = .failed
            return
        }
    }
}
