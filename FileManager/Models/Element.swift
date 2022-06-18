//
//  Element.swift
//  FileManager
//
//  Created by Oleshkevich Artem on 3.06.22.
//

import Foundation

struct Element {
    let name: String
    let path: URL
    
    let type: ElementType
}

enum ElementType {
    case folder
    case image
    
    var sortPriority: Int {
        switch self {
        case .folder:
            return 0
            
        case .image:
            return 1
        }
    }
}
