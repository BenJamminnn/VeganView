//
//  ResultsFoundViewController.swift
//  VeganView
//
//  Created by Ben Gabay on 8/22/22.
//

import UIKit

class ResultsFoundViewController: UIViewController, UITableViewDelegate {
    
    var lineItems = [String: String]() {
        didSet {
            setupTableViewWithItems(lineItems: lineItems)
            nonVeganTableView.reloadData()
        }
    }
    
    private var nonVeganTableView = NonVeganTableView(frame: .zero, lineItems: [:])

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setupTableViewWithItems(lineItems: [String: String]) {
        if nonVeganTableView.superview != nil {
            nonVeganTableView.removeFromSuperview()
        }
        let tableViewRectOrigin = CGPoint(x: 10, y: view.center.y - 200)
        let tableViewRectSize = CGSize(width: view.frame.width - 20, height: 500)
        let tableViewRect = CGRect(origin: tableViewRectOrigin, size: tableViewRectSize)
        nonVeganTableView = NonVeganTableView(frame: tableViewRect, lineItems: lineItems)
        nonVeganTableView.delegate = self
        view.addSubview(nonVeganTableView)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    
    @IBAction func scanAgainClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
