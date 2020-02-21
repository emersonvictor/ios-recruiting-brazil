//
//  FiltersController.swift
//  movs
//
//  Created by Emerson Victor on 02/12/19.
//  Copyright © 2019 emer. All rights reserved.
//

import UIKit

class FiltersController: UIViewController {
    
    // MARK: - Coordinator
    typealias FiltersCoordinatorOutput = FiltersDelegate & Coordinator
    weak var coordinator: FiltersCoordinatorOutput?
    
    // MARK: - Attributes
    lazy var screen = FiltersScreen(controller: self)
    var filters: [FilterType: String?]
    var filtersArray: [FilterType]
    
    // MARK: - Initializers
    required init(filters: [FilterType: String?]) {
        self.filtersArray = FilterType.allCases.sorted()
        self.filters = filters
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View controller life cycle
    override func loadView() {
        super.loadView()
        self.title = "Filters"
        self.view = self.screen
        self.screen.applyButton.addTarget(self,
                                          action: #selector(applyFilters),
                                          for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let filters = self.coordinator?.filters {
            self.filters = filters
        }
        self.screen.filtersTableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    // MARK: - Apply filters action
    @objc func applyFilters() {
        self.coordinator?.applyFilters()
    }
}

// MARK: - Table view data source
extension FiltersController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filtersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let filterType = self.filtersArray[indexPath.row]
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = filterType.rawValue
        cell.detailTextLabel?.text = self.filters[filterType] ?? nil
        
        return cell
    }
}

// MARK: - Table view delegate
extension FiltersController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filterType = self.filtersArray[indexPath.row]
        self.coordinator?.showFilter(of: filterType)
    }
}
