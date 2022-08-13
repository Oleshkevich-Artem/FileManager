//
//  ViewController.swift
//  FileManager
//
//  Created by Oleshkevich Artem on 2.06.22.
//

import PhotosUI
import UIKit
import UserNotifications

class FilesViewController: UIViewController {
    
    @IBOutlet weak var filesCollectionView: UICollectionView!
    @IBOutlet weak var foldersTableView: UITableView!
    
    var manager = ElementsManager()
    
    var verificationStatus: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        checkVerificationStatus()
        setUpDisplayMode()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        updateNavigationButtons()
        enableNotifications()
   
        setUpTableView()
        setUpCollectionView()
    }
    
    // MARK: - Display mode
    
    private func setUpDisplayMode() {
        let savedDisplayMode = UserDefaultsService.shared.getDisplayMode(key: DisplayMode.key)
        self.manager.displayMode = savedDisplayMode == DisplayMode.tableView.rawValue ? .tableView : .collectionView
    }
    
    // MARK: - Navigation Bar, UIMenu, Manipulations
    
    private func setUpNavigationBarViewMode() {
        
        let submenu = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "Collection",
                     image: UIImage(systemName: "rectangle.grid.2x2"),
                     handler: { [weak self] _ in
                         self?.manager.setDisplayModeSettings(.collectionView)
                         UserDefaultsService.shared.saveDisplayMode(mode: .collectionView, key: DisplayMode.key)
                         
                     }),
            UIAction(title: "Table",
                     image: UIImage(systemName: "list.bullet"),
                     handler: { [weak self] _ in
                         self?.manager.setDisplayModeSettings(.tableView)
                         UserDefaultsService.shared.saveDisplayMode(mode: .tableView, key: DisplayMode.key)
                     })
            ])
        
        let menu = UIMenu(title: "Menu",
                          image: UIImage(systemName: ""),
                          children: [
            UIAction(title: "New folder",
                     image: UIImage(systemName: "folder"),
                     handler: { [weak self] _ in self?.showCreateFolderAlert() }),
            UIAction(title: "Camera",
                     image: UIImage(systemName: "camera"),
                     handler: { [weak self] _ in self?.uploadCameraPhoto() }),
            UIAction(title: "Upload image",
                     image: UIImage(systemName: "photo"),
                     handler: { [weak self] _ in self?.uploadImage() }),
            UIAction(title: "Edit",
                     image: UIImage(systemName: "folder.badge.minus"),
                     attributes: .destructive,
                     handler: { [weak self] _ in self?.manager.switchMode(.edit) }),
            submenu
        ])
        
        let menuButton = UIBarButtonItem(title: "Menu", image: UIImage(systemName: "text.justify"), primaryAction: nil, menu: menu)
        navigationItem.title = "File Manager"
        navigationItem.backButtonDisplayMode = .generic
        navigationItem.rightBarButtonItems = [menuButton]
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setUpNavigationBarEditMode() {
        let selectButton = UIBarButtonItem(systemItem: .cancel,
                                           primaryAction: UIAction(handler: { [weak self] _ in
            self?.manager.switchMode(.view)
        }))
        
        let deleteButton = UIBarButtonItem(systemItem: .trash,
                                           primaryAction: UIAction(handler: { [weak self] _ in
            self?.manager.deleteSelectedElements()
        }))
        
        navigationItem.rightBarButtonItems = [selectButton, deleteButton]
    }
   
    func updateNavigationButtons() {
        switch manager.mode {
        case .edit:
            setUpNavigationBarEditMode()
            
        case .view:
            setUpNavigationBarViewMode()
        }
    }
        
    private func showCreateFolderAlert() {
        let alertController = UIAlertController(title: "New Folder",
                                                message: nil,
                                                preferredStyle: .alert)
        
        alertController.addTextField {
            $0.placeholder = "Folder Name"
        }
        
        let addAction = UIAlertAction(title: "Add",
                                      style: .default,
                                      handler: { [weak self] _ in
            guard let folderName = alertController.textFields?.first?.text,
                !folderName.isEmpty else {
                self?.showCreateFolderAlert()
                
                return
            }
            
            self?.manager.createElement(type: .folder, name: folderName)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func uploadCameraPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        
        imagePicker.allowsEditing = true
        
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    private func uploadImage() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        
        let pickerViewController = PHPickerViewController(configuration: configuration)
        
        pickerViewController.delegate = self
        
        present(pickerViewController, animated: true)
    }

    func handleCellTap(indexPath: IndexPath) {
        let element = manager.elements[indexPath.row]
        
        switch manager.mode {
        case .edit:
            manager.selectElement(element)
            
        case .view:
            handleViewModeCellTap(element: element)
        }
    }
    
    private func handleViewModeCellTap(element: Element) {
        switch element.type {
        case .folder:
            navigateToNextFolder(element.path)
        case .image:
            navigateToImageViewController(element.path)
        }
    }
            
    private func navigateToNextFolder(_ url: URL) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilesViewController") as? FilesViewController else {
            return
        }
        viewController.verificationStatus = self.verificationStatus
        viewController.manager.currentDirectory = url
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func navigateToImageViewController(_ url: URL) {
        guard let imageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController else {
            return
        }
        imageViewController.imageURL = url
        
        self.navigationController?.pushViewController(imageViewController, animated: true)
    }
    
    // MARK: - LocalNotificationService manipulations
    
    private func enableNotifications() {
        LocalNotificationsService.shared.requestNotificationsPermissions()
    }
}
