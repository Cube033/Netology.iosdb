//
//  ViewController.swift
//  Netology.iosdb
//
//  Created by Дмитрий Федотов on 01.11.2022.
//

import UIKit

class FilesViewController: UIViewController {
    
    var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    var observer: NSKeyValueObservation?
    
    var contentArray: [URL] {
        do {
            let userDefaults = UserDefaults.standard
            let sortingTypeIsASC = userDefaults.bool(forKey: "sortingTypeIsASC")
            var arrayURL = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            if sortingTypeIsASC {
                arrayURL.sort(by: { $0.description < $1.description })
            } else {
                arrayURL.sort(by: { $0.description > $1.description })
            }
            return arrayURL
        } catch {
            let emptyArray: [URL] = []
            return emptyArray
        }
    }
    
    private(set) var coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator){
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        observer = UserDefaults.standard.observe(\.sortingTypeIsASC, options: [.initial, .new], changeHandler: { (defaults, change) in
                self.fileManagerTableView.reloadData()
            })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    @objc private func presentImagePicker() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.modalPresentationStyle = .popover
        imagePickerVC.allowsEditing = false
        imagePickerVC.delegate = self
        self.present(imagePickerVC, animated: true)
    }
    
    private lazy var fileManagerTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private func setView() {
        view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Добавить фотографию", style: .plain, target: self, action: #selector(presentImagePicker))
        view.addSubview(fileManagerTableView)
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            fileManagerTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fileManagerTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            fileManagerTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fileManagerTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            fileManagerTableView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
    }
    
    private func setAlert(errorMessage: String) {
        let alert = UIAlertController(title: "Ошибка", message: errorMessage, preferredStyle: .alert)
        let actionDismiss = UIAlertAction(title: "Закрыть", style: .default) { (_) -> Void in
            
        }
        alert.addAction(actionDismiss)
        self.present(alert, animated: true, completion: nil)
    }
}

extension FilesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = contentArray[indexPath.row]
            do {
                try FileManager.default.removeItem(at: item)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                setAlert(errorMessage: "Ошибка удаления")
            }
        }
    }
}

extension FilesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let item = contentArray[indexPath.row]
        cell.textLabel?.text = item.lastPathComponent
        return cell
    }
}

extension FilesViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageURL = info[.imageURL] as? URL {
            let fileName = Date().description + ".jpeg"
            let destURL = self.url.appendingPathComponent(fileName)
            do {
                try FileManager.default.copyItem(at: imageURL, to: destURL)
                self.fileManagerTableView.reloadData()
            } catch {
                setAlert(errorMessage: "Ошибка копирования фотографии")
            }
        } else {
            setAlert(errorMessage: "Ошибка открытия фотографии")
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension FilesViewController: UINavigationControllerDelegate {
    
}

extension UserDefaults {
    @objc dynamic var sortingTypeIsASC: Bool {
        return bool(forKey: "sortingTypeIsASC")
    }
}
