//
//  ElementCollectionViewCell.swift
//  FileManager
//
//  Created by Oleshkevich Artem on 7.06.22.
//

import UIKit

class ElementCollectionViewCell: UICollectionViewCell, FileProtocol {
    static let id = "ElementCollectionViewCell"
    
    var elementImageView: UIImageView!
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        createElements()
    }

    private func createElements() {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.distribution = .fillEqually
        verticalStack.spacing = 5
        
        addSubview(verticalStack)
        
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            verticalStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            verticalStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 5)
        ])
        
        let imageView = UIImageView()
        imageView.tintColor = .red
        self.elementImageView = imageView
        verticalStack.addArrangedSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
     
        let label = UILabel()
        self.label = label
        
        verticalStack.addArrangedSubview(label)
    }
}

protocol FileProtocol: AnyObject {
    var elementImageView: UIImageView! { get }
    var label: UILabel! { get }
    
    var backgroundColor: UIColor? { get set }
    
    func updateData(element: Element, selected: Bool)
}

extension FileProtocol {
    func updateData(element: Element, selected: Bool) {
        updateImage(element: element)
        
        self.label.text = element.name
        
        self.backgroundColor = selected ? .lightGray : .clear
    }
    
    private func updateImage(element: Element) {
        let image: UIImage?
        
        switch element.type {
        case .folder:
            image = UIImage(systemName: "folder.fill")
            
        case .image:
            guard let data = try? Data(contentsOf: element.path) else {
                return
            }
            
            image = UIImage(data: data)
        }
        
        self.elementImageView.image = image
    }
}
