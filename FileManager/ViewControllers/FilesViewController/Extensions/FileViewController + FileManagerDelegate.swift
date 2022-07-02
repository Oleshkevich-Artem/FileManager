//
//  FileViewController + FileManagerDelegate.swift
//  FileManager
//
//  Created by Oleshkevich Artem on 1.07.22.
//

import UIKit

extension FilesViewController: ElementsManagerDelegate {
    func handleDisplayModeChange() {
        switch manager.displayMode {
        case .tableView:
            foldersTableView.isHidden = false
            filesCollectionView.isHidden = true
        case .collectionView:
            foldersTableView.isHidden = true
            filesCollectionView.isHidden = false
        }
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
