//
//  AnalysisViewController.swift
//  VeganView
//
//  Created by Ben Gabay on 8/21/22.
//

import UIKit

class AnalysisViewController: UIViewController, UITableViewDelegate {

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

        // Title
        let titleOrigin = CGPoint(x: 0, y: 50)
        let titleSize = CGSize(width: view.frame.width, height: 80)
        
        let titleRect = CGRect(origin: titleOrigin, size: titleSize)
        let resultTitle = UILabel(frame: titleRect)
        resultTitle.textAlignment = .center
        resultTitle.font = UIFont(name: "Verdana-Bold", size: 24)
        resultTitle.text = "Results"
        resultTitle.textColor = UIColor.black
        view.addSubview(resultTitle)
        
        // Label
        let labelWidth = 400
        let rectOrigin = CGPoint(x: view.center.x - CGFloat(labelWidth/2), y: view.center.y - 50)
        let unit = 100
        let centeredRect = CGRect(origin: view.center, size: CGSize(width: unit, height: unit))
        let labelRect = CGRect(origin: rectOrigin, size: CGSize(width: labelWidth, height: 100))
        resultLabel.frame = labelRect
        resultLabel.numberOfLines = 0
        resultLabel.textAlignment = .center
        
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
                    self.setupTableViewWithItems(lineItems: results)
                    self.resultLabel.text = "NOT VEGAN"
                }
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func setupTableViewWithItems(lineItems: [String: String]) {
        let tableViewRectOrigin = CGPoint(x: 10, y: self.view.center.y - 50)
        let tableViewRectSize = CGSize(width: self.view.frame.width - 20, height: 400)
        let tableViewRect = CGRect(origin: tableViewRectOrigin, size: tableViewRectSize)
        let resultingTable = NonVeganTableView(frame: tableViewRect, lineItems: lineItems)
        resultingTable.delegate = self
        view.addSubview(resultingTable)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
