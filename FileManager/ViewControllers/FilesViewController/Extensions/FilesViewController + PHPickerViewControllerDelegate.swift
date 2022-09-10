//
//  FilesViewController + PHPickerViewControllerDelegate.swift
//  FileManager
//
//  Created by Oleshkevich Artem on 1.07.22.
//

import UIKit
import PhotosUI

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
