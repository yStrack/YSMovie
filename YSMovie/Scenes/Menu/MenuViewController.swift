//
//  MenuViewController.swift
//  YSMovie
//
//  Created by ystrack on 23/01/24.
//

import UIKit

final class MenuViewController: UIViewController {
    
    // MARK: Constants
    private let cellIdentifier: String = "DefaultSettingsCell"
    
    // MARK: Views
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray6
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        return tableView
    }()
    
    private lazy var closeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage.xmark
        let button = UIButton(configuration: configuration, primaryAction: UIAction { _ in
            self.dismiss(animated: true)
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
    }
    
    // MARK: Setup Subviews
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(closeButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

// MARK: UITableView Delegate Extension
extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}

// MARK: UITableView DataSource Extension
extension MenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = String(localized: "Third-party APIs")
        contentConfiguration.image = UIImage(systemName: "antenna.radiowaves.left.and.right")
        contentConfiguration.imageProperties.tintColor = .white
        
        var backgroundConfiguration = cell.defaultBackgroundConfiguration()
        backgroundConfiguration.backgroundColor = .clear
        
        cell.contentConfiguration = contentConfiguration
        cell.backgroundConfiguration = backgroundConfiguration
        
        return cell
    }
}
