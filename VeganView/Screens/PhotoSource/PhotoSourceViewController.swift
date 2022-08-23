//
//  PhotoSourceViewController.swift
//  VeganView
//
//  Created by Ben Gabay on 8/21/22.
//

import UIKit
import PhotosUI

class PhotoSourceViewController: UIViewController, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var chosenImportedImage: UIImage?
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
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
                self.analyzeImage(image: image)
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
                            self.analyzeImage(image: chosenImage)
                        }
                    }
                }
            }
        }
    }
    
    private func analyzeImage(image: UIImage) {
        OCRUtil.recognizeText(image: image) { [weak self] result, error in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard let result = result,
                      error == nil else {
                    // Process Error
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "Error Found: \(String(describing: error?.localizedDescription))"
                    return
                }
                self.errorLabel.isHidden = true

                // Returns offending words
                let results = self.processResult(wordResult: result)
                if results.isEmpty {
                    self.presentResultsNotFound()
                } else {
                    self.presentResultsFoundWithLineItems(lineItems: results)
                }
            }
        }
    }
    
    private func processResult(wordResult: [String]) -> [String: String] {
        var offendingWords = [String: String]()
        for ingredient in wordResult {
            for nonVeganIngredient in nonVeganIngredients {
                if ingredient.lowercased().contains(nonVeganIngredient.lowercased()) {
                    if !excludedList.contains(ingredient.lowercased()) {
                        offendingWords[ingredient] = nonVeganIngredient
                    }
                }
            }
        }
        return offendingWords
    }
    
    private func presentResultsNotFound() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let resultFoundVC = sb.instantiateViewController(withIdentifier: StoryboardIdentifiers.resultsNotFound.rawValue)
        resultFoundVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(resultFoundVC, animated: true)
    }
    
    private func presentResultsFoundWithLineItems(lineItems: [String: String]) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let resultFoundVC = sb.instantiateViewController(withIdentifier: StoryboardIdentifiers.resultsFound.rawValue) as? ResultsFoundViewController {
            resultFoundVC.lineItems = lineItems
            resultFoundVC.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(resultFoundVC, animated: true)
        }
    }
}
