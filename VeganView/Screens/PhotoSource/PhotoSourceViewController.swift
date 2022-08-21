//
//  PhotoSourceViewController.swift
//  VeganView
//
//  Created by Ben Gabay on 8/21/22.
//

import UIKit
import PhotosUI

class PhotoSourceViewController: UIViewController, PHPickerViewControllerDelegate, CameraEventDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var chosenImportedImage: UIImage?
    var imagePicker = UIImagePickerController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Actions
    @IBAction func captureClicked(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[.originalImage] as? UIImage {
            self.imagePicker.dismiss(animated: true, completion: {
                let analysisViewController = AnalysisViewController(image: image)
                self.navigationController?.pushViewController(analysisViewController, animated: true)
            })
        }
    }
    
    @IBAction func importClicked(_ sender: Any) {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let provider = results.first?.itemProvider else { return }

        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                if let chosenImage = image as? UIImage {
                    DispatchQueue.main.async {
                        picker.dismiss(animated: true) {
                            let analysisViewController = AnalysisViewController(image: chosenImage)
                            self.navigationController?.pushViewController(analysisViewController, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Camera Event
    func errorDidOccur(error: CameraError) {
        
    }
    
    func cameraImageCaptured(image: UIImage) {
        
    }
}
