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
    private var orderedKeys = [String]()
    
    init(frame: CGRect, lineItems: [String: String]) {
        self.lineItems = lineItems
        super.init(frame: frame, style: .plain)
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = 10
        register(NonVeganItemTableViewCell.self, forCellReuseIdentifier: NonVeganItemTableViewCell.cellIdentifier)
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
        
        let cell: NonVeganItemTableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NonVeganItemTableViewCell.cellIdentifier, for: indexPath) as? NonVeganItemTableViewCell else {
                return NonVeganItemTableViewCell(style: .default, reuseIdentifier: NonVeganItemTableViewCell.cellIdentifier)
            }
            return cell
        }()
        
        let key = orderedKeys[indexPath.row]
        cell.configure(key, lineItems[key] ?? "Not Found")
        return cell
    }
}

class NonVeganItemTableViewCell: UITableViewCell {
    static let cellIdentifier = "analysisCell"

    private var matchedIngredientLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana-SemiBold", size: 8)
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    private var ingredientLineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana-SemiBold", size: 8)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        selectionStyle = .none
        // Offending Line
        let height = 16.0
        let origin = CGPoint(x: 10, y: center.y - height/2.0)
        let width = frame.width/2 - 5
        let size = CGSize(width: width, height: height)
        ingredientLineLabel.frame = CGRect(origin: origin, size: size)
        addSubview(ingredientLineLabel)
        
        // Offending Ingredient Found
        let originDetail = CGPoint(x: frame.width - 10.0, y: center.y - height/2.0)
        matchedIngredientLabel.frame = CGRect(origin: originDetail, size: size)
        addSubview(matchedIngredientLabel)
    }
    
    func configure(_ offendingLine: String, _ ingredient: String) {
        ingredientLineLabel.text = offendingLine
        matchedIngredientLabel.text = ingredient
    }
}
