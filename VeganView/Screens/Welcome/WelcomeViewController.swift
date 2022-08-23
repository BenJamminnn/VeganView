//
//  ViewController.swift
//  VeganView
//
//  Created by Ben Gabay on 8/21/22.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func getStartedClicked(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let photoSourceVC = sb.instantiateViewController(withIdentifier: StoryboardIdentifiers.choose.rawValue)
        photoSourceVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(photoSourceVC, animated: true)
    }
}
