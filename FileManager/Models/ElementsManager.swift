//
//  ElementsManager.swift
//  FileManager
//
//  Created by Oleshkevich Artem on 3.06.22.
//

import Foundation
import UIKit

class ElementsManager {
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
                                                                           includingPropertiesForKeys: nil) else {
            return
        }
        
        self.elements = filesUrls.map {
            let name = $0.lastPathComponent
            
            let type: ElementType = name.contains(".png") || name.contains(".jpeg") ? .image : .folder
            
            return Element(name: name,
                           path: $0,
                           type: type)
        }.sorted {
            $0.type.sortPriority < $1.type.sortPriority
        }
        
        delegate?.reloadData()
    }
}
