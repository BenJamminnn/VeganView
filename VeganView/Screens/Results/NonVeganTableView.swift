//
//  NonVeganTableView.swift
//  VeganView
//
//  Created by Ben Gabay on 8/21/22.
//

import UIKit

class NonVeganTableView: UITableView, UITableViewDataSource {
    // Offending line : Ingredient Found
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
        
        let header = TableViewHeader(frame: CGRect(x: 0, y: 0, width: frame.width, height: 40))
        tableHeaderView = header
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") ?? UIView()
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

class TableViewHeader : UIView{

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupLabel(){
        let offendingIngredientOrigin = CGPoint(x: 10, y: center.y)
        let size = CGSize(width: 300, height: 20)
        let offendingIngredientLabel = UILabel(frame: CGRect(origin: offendingIngredientOrigin, size: size))
        offendingIngredientLabel.font = UIFont(name: "Verdana-Bold", size: 12)
        offendingIngredientLabel.text = "Offending Line"
        offendingIngredientLabel.textAlignment = .left
        offendingIngredientLabel.textColor = UIColor.black
        addSubview(offendingIngredientLabel)
        
        let foundIngredientOrigin = CGPoint(x: frame.width - 140, y: center.y)
        let foundIngredientLabel = UILabel(frame: CGRect(origin: foundIngredientOrigin, size: size))
        foundIngredientLabel.font = UIFont(name: "Verdana-Bold", size: 12)
        foundIngredientLabel.text = "Found Ingredient"
        foundIngredientLabel.textColor = UIColor.black
        addSubview(foundIngredientLabel)
    }
}

class NonVeganItemTableViewCell: UITableViewCell {
    static let cellIdentifier = "analysisCell"

    private var matchedIngredientLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana-Bold", size: 10)
        label.numberOfLines = 0
        label.textAlignment = .right
        label.textColor = UIColor.darkGray
        return label
    }()
    
    private var ingredientLineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana-Bold", size: 10)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor.darkGray
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
        let height = 40.0
        let origin = CGPoint(x: 10, y: center.y)
        let width = frame.width/2 + 20
        let size = CGSize(width: width, height: height)
        ingredientLineLabel.frame = CGRect(origin: origin, size: size)
        addSubview(ingredientLineLabel)
        
        // Offending Ingredient Found
        let originDetail = CGPoint(x: frame.width/2 - 10.0, y: center.y)
        matchedIngredientLabel.frame = CGRect(origin: originDetail, size: size)
        addSubview(matchedIngredientLabel)
    }
    
    func configure(_ offendingLine: String, _ ingredient: String) {
        ingredientLineLabel.text = offendingLine
        matchedIngredientLabel.text = ingredient
    }
}
