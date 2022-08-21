//
//  AnalysisViewController.swift
//  VeganView
//
//  Created by Ben Gabay on 8/21/22.
//

import UIKit

class AnalysisViewController: UIViewController {

    private var activityIndicator = UIActivityIndicatorView()
    
    let analysisImage: UIImage

    private var resultLabel = UILabel()
    
    init(image: UIImage) {
        self.analysisImage = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGreen
        let unit = 100
        let centeredRect = CGRect(origin: self.view.center, size: CGSize(width: unit, height: unit))
        let labelOrigin = CGPoint(x: 10, y: self.view.center.y)
        let labelRect =  CGRect(origin: labelOrigin, size: CGSize(width: self.view.frame.width, height: 100))
        resultLabel.frame = labelRect
        resultLabel.numberOfLines = 0
        
        view.addSubview(resultLabel)
        
        activityIndicator.frame = centeredRect
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        OCRUtil.recognizeText(image: analysisImage) { [weak self] result, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let result = result,
                      error == nil else {
                    // Process Error
                    self.activityIndicator.stopAnimating()
                    return
                }

                // Returns offending words
                let results = self.processResult(wordResult: result)
                if results.isEmpty {
                    // No Offending words, item is vegan
                    self.resultLabel.text = "ITS VEGAN"
                } else {
                    self.resultLabel.text = "ITS NOT VEGAN \(results)"
                }
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func processResult(wordResult: [String]) -> [String] {
        var offendingWords = [String]()
        for ingredient in wordResult {
            for nonVeganIngredient in nonVeganIngredients {
                if ingredient.lowercased().contains(nonVeganIngredient.lowercased()) {
                    if !excludedList.contains(ingredient.lowercased()) {
                        offendingWords.append(ingredient)
                    }
                }
            }
        }
        return offendingWords
    }
}
