//
//  CameraViewController.swift
//  VeganVision
//
//  Created by Ben Gabay on 8/21/22.
//

import UIKit
import AVFoundation

protocol CameraEventDelegate: AnyObject {
    func errorDidOccur(error: CameraError)
    func cameraImageCaptured(image: UIImage)
}

class CameraViewController: UIViewController {

    private let photoOutput = AVCapturePhotoOutput()
    
    weak var delegate: CameraEventDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initiateCamera()
    }
    
    private func initiateCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                if !authorized {
                    self.showErrorToastMessage(cameraError: .deniedAuth)
                }
                self.setupCaptureSession()
            }
        case .restricted:
            self.showErrorToastMessage(cameraError: .restrictedAuth)
        case .denied:
            self.showErrorToastMessage(cameraError: .deniedAuth)
        case .authorized:
            setupCaptureSession()
            break
        @unknown default:
            self.showErrorToastMessage(cameraError: .unknownAuthorization)
        }
    }
    
    private func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        if let captureDevice = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                } else {
                    self.showErrorToastMessage(cameraError: .cannotAddInput)
                }
            } catch {
                self.showErrorToastMessage(cameraError: .createCaptureInput(error: error))
            }
            
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            cameraLayer.frame = view.frame
            cameraLayer.videoGravity = .resizeAspect
            
            view.layer.addSublayer(cameraLayer)
            
            captureSession.startRunning()
        }
    }
    
    private func showErrorToastMessage(cameraError: CameraError) {
        
    }
}


