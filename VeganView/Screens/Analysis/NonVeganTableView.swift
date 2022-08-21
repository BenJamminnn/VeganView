//
//  NonVeganTableView.swift
//  VeganView
//
//  Created by Ben Gabay on 8/21/22.
//

import UIKit

class NonVeganTableView: UITableView, UITableViewDataSource {
    // Offending line : Ingridient Found
    private let lineItems: [String: String]
    private let cellIdentifier = "analysisCell"
    private var orderedKeys = [String]()
    
    init(frame: CGRect, lineItems: [String: String]) {
        self.lineItems = lineItems
        super.init(frame: frame, style: .plain)
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = 10
        register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        orderedKeys = Array(lineItems.keys).sorted()
        dataSource = self
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lineItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        let key = orderedKeys[indexPath.row]
        cell.textLabel?.text = key
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont(name: "Verdana-SemiBold", size: 10)
        cell.detailTextLabel?.text = lineItems[key]
        return cell
    }
}
