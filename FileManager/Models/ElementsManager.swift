//
//  ElementsManager.swift
//  FileManager
//
//  Created by Oleshkevich Artem on 3.06.22.
//

import Foundation
import UIKit

class ElementsManager {
    var mode: EditingMode = .view {
        didSet {
            delegate?.handleModeChange()
        }
    }
    
    var displayMode: DisplayMode = .tableView {
        didSet {
            delegate?.handleDisplayModeChange()
        }
    }
    
    private let imagesExtensions = [".jpeg", ".jpg", ".png", ".heic"]
    
    var selectedElements = [Element]()
    var elements = [Element]()
    
    var currentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        didSet {
            reloadFolderContents()
        }
    }
    
    var delegate: ElementsManagerDelegate?
    
    init() {
        reloadFolderContents()
    }
    
    func switchMode(_ mode: EditingMode) {
        self.mode = mode
        
        switch mode {
        case .view:
            self.selectedElements = []
            
        case .edit:
            break
        }
    }
    
    func setDisplayModeSettings(_ displayMode: DisplayMode) {
        self.displayMode = displayMode
    }
    
    func createElement(type: ElementType, name: String) {
        switch type {
        case .folder:
            createFolder(name: name)
            
        default:
            break
        }
        
        reloadFolderContents()
    }
    
    private func createFolder(name: String) {
        guard let currentDirectory = currentDirectory else {
            return
        }
        
        let newFolderPath = currentDirectory.appendingPathComponent(name)
        
        try? FileManager.default.createDirectory(at: newFolderPath,
                                                 withIntermediateDirectories: false,
                                                 attributes: nil)
    }
    
    func createImage(_ image: UIImage, name: String) {
        guard let currentDirectory = self.currentDirectory,
              let data = image.jpegData(compressionQuality: 1) else {
            return
        }
        
        let newImagePath = currentDirectory.appendingPathComponent(name)
        
        try? data.write(to: newImagePath)
        
        reloadFolderContents()
    }
    
    private func reloadFolderContents() {
        guard let currentDirectory = self.currentDirectory,
              let filesUrls = try? FileManager.default.contentsOfDirectory(at: currentDirectory,
                                                                           includingPropertiesForKeys: nil) else { return }
        
        self.elements = filesUrls.map {
            let name = $0.lastPathComponent

            let type: ElementType = imagesExtensions.contains(where: { name.contains($0) })
                ? .image : .folder

            return Element(name: name,
                           path: $0,
                           type: type)
        }.sorted {
            $0.type.sortPriority < $1.type.sortPriority
        }

        delegate?.reloadData()
    }
    
    func selectElement(_ element: Element) {
        guard mode == .edit else { return }
        
        if let index = selectedElements.firstIndex(of: element) {
            selectedElements.remove(at: index)
        }
        else {
            selectedElements.append(element)
        }
        
        delegate?.reloadData()
        
        print(selectedElements)
    }
    
    func deleteSelectedElements() {
        guard mode == .edit else { return }
        
        for element in selectedElements {
            try? FileManager.default.removeItem(at: element.path)
        }
        
        switchMode(.view)
        
        reloadFolderContents()
    }
}
