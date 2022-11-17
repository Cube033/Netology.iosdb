//
//  SettingsViewController.swift
//  Netology.iosdb
//
//  Created by Дмитрий Федотов on 13.11.2022.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    private(set) var coordinator: MainCoordinator
    
    private var sortingTypeIsASC: Bool = true
    
    init(coordinator: MainCoordinator){
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let userDefaults = UserDefaults.standard
        if let sortingTypeDefaults = userDefaults.object(forKey: "sortingTypeIsASC") as? Bool {
            sortingTypeIsASC = sortingTypeDefaults
        } else {
            sortingTypeIsASC = true
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "Сортировка по возрастанию"
            return cell
        case 1:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "Сбросить пароль"
            return cell
        default:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && sortingTypeIsASC == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            sortingTypeIsASC.toggle()
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(sortingTypeIsASC, forKey: "sortingTypeIsASC")
            tableView.reloadData()
        case 1:
            let res = KeyChainService.shared.deletePassword(login: "default", serviceName: "Netology.iosdb")
            switch res {
            case .success(let descr):
                print(descr)
            case .fault(let descr):
                print(descr)
            }
            coordinator.handleAction(actionType: .startApplication)
        default:
            break
        }
    }
}


