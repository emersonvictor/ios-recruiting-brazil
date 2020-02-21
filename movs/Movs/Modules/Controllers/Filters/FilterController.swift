//
//  FilterController.swift
//  movs
//
//  Created by Emerson Victor on 02/12/19.
//  Copyright © 2019 emer. All rights reserved.
//

import UIKit

class FilterController: UIViewController {
    
    // MARK: - Coordinator
    typealias FilterCoordinatorOutput = FilterDelegate & Coordinator
    weak var coordinator: FilterCoordinatorOutput?
    
    // MARK: - Attributes
    lazy var screen = FilterScreen(controller: self)
    let filterType: FilterType
    let values: [String]
    var selectedValue: String?
    
    // MARK: - Initializers
    required init(filterType: FilterType, selectedValue: String?) {
        self.filterType = filterType
        self.values = filterType.values
        self.selectedValue = selectedValue
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View controller life cycle
    override func loadView() {
        super.loadView()
        self.view = self.screen
        self.title = self.filterType.rawValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    override func willMove(toParent parent: UIViewController?) {
        self.coordinator?.didSelect(self.selectedValue, for: self.filterType)
        super.willMove(toParent: parent)
    }
}

// MARK: - Table view data source
extension FilterController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let value = self.values[indexPath.row]
        
        cell.textLabel?.text = value
        cell.selectionStyle = .none
        cell.tintColor = .label
        if value == self.selectedValue {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
}

// MARK: - Table view delegate
extension FilterController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)!
        
        // Check if exists a selected value
        if let selectedValue = self.selectedValue,
            let index = self.values.firstIndex(of: selectedValue) {
            
            let lastSelectedCell = tableView.cellForRow(at: IndexPath(item: index, section: 0))!
            lastSelectedCell.accessoryType = .none
            
            // If the selected cell was the last selected cell remove value and checkmark
            if selectedValue == selectedCell.textLabel?.text {
                self.selectedValue = nil
                return
            }
        }
        
        self.selectedValue = self.values[indexPath.row]
        selectedCell.accessoryType = .checkmark
    }
}
