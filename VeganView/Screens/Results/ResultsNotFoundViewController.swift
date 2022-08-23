//
//  ResultsNotFoundViewController.swift
//  VeganView
//
//  Created by Ben Gabay on 8/22/22.
//

import UIKit

class ResultsNotFoundViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBAction func click(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
