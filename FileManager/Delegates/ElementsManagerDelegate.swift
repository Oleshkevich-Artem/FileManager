//
//  ElementsManagerDelegate.swift
//  FileManager
//
//  Created by Oleshkevich Artem on 3.06.22.
//

import Foundation

protocol ElementsManagerDelegate {
    func reloadData()
    func handleModeChange()
    func handleDisplayModeChange()
}
