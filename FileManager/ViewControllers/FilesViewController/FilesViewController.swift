//
//  ViewController.swift
//  FileManager
//
//  Created by Oleshkevich Artem on 2.06.22.
//

import PhotosUI
import UIKit

class FilesViewController: UIViewController {
    
    
    @IBOutlet weak var filesCollectionView: UICollectionView!
    @IBOutlet weak var foldersTableView: UITableView!
    
    var manager = ElementsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
    
        updateNavigationButtons()
        updateDisplayMode()
        
        setUpTableView()
        setUpCollectionView()
        
    }
    
    private func setUpNavigationBarViewMode() {
        
        let menu = UIMenu(title: "Menu", image: UIImage(systemName: "buss.fill"), children: [
            UIAction(title: "New folder", image: UIImage(systemName: "folder"), handler: { _ in self.showCreateFolderAlert() }),
            UIAction(title: "Camera", image: UIImage(systemName: "camera"), handler: { _ in self.uploadCameraPhoto() }),
            UIAction(title: "Upload image", image: UIImage(systemName: "photo"), handler: { _ in self.uploadImage() }),
            UIAction(title: "Edit", image: UIImage(systemName: "folder.badge.minus"), attributes: .destructive, handler: { _ in self.manager.switchMode(.edit) })
        ])
        
        let displayModeButton = UIBarButtonItem(systemItem: .action, primaryAction: UIAction(handler: { _ in self.manager.switchDisplayMode() }))
        
        let menuButton = UIBarButtonItem(title: "Menu", image: UIImage(systemName: "square.and.pencil"), primaryAction: nil, menu: menu)
        
        navigationItem.rightBarButtonItems = [menuButton, displayModeButton]
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func updateDisplayMode() {
        switch manager.displayMode {
        case .tableView:
            filesCollectionView.isHidden = false
            foldersTableView.isHidden = true
            
        case .collectionView:
            filesCollectionView.isHidden = true
            foldersTableView.isHidden = false
        }
    }
    
    private func setUpNavigationBarEditMode() {
        let selectButton = UIBarButtonItem(systemItem: .cancel,
                                           primaryAction: UIAction(handler: { _ in
            self.manager.switchMode(.view)
        }))
        
        let deleteButton = UIBarButtonItem(systemItem: .trash,
                                           primaryAction: UIAction(handler: { _ in
            self.manager.deleteSelectedElements()
        }))
        
        navigationItem.rightBarButtonItems = [selectButton, deleteButton]
    }
   
    private func updateNavigationButtons() {
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
                                      handler: { _ in
            guard let folderName = alertController.textFields?.first?.text,
                !folderName.isEmpty else {
                self.showCreateFolderAlert()
                
                return
            }
            
            self.manager.createElement(type: .folder, name: folderName)
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
    
    // MARK: Cells manipulation
    
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
}

extension FilesViewController: ElementsManagerDelegate {
    func handleDisplayModeChange() {
        updateDisplayMode()
    }
    
    func handleModeChange() {
        updateNavigationButtons()
        reloadData()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.foldersTableView.reloadData()
            self.filesCollectionView.reloadData()
        }
    }
}

extension FilesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage,
              let imageName = (info[.imageURL] as? URL)?.lastPathComponent else {
            return
        }
        
        manager.createImage(image, name: imageName)
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension FilesViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        itemProvider.loadObject(ofClass: UIImage.self) { image, error in
            guard let image = image as? UIImage else {
                return
            }

            self.getImageName(itemProvider: itemProvider) { imageName in
                guard let imageName = imageName else {
                    return
                }
                
                self.manager.createImage(image, name:imageName)
            }
        }
        picker.dismiss(animated: true)
    }
    
    private func getImageName(itemProvider: NSItemProvider, callback: @escaping (String?) -> Void) {
        guard itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) else {
            callback(nil)
            return
        }
        
        itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { data, error in
            callback(data?.lastPathComponent)
        }
    }
}
