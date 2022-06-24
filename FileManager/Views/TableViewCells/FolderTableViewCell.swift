//
//  FolderTableViewCell.swift
//  FileManager
//
//  Created by Oleshkevich Artem on 3.06.22.
//

import UIKit

class FolderTableViewCell: UITableViewCell, FileProtocol {
    static let id = "FolderTableViewCell"
    
    var elementImageView: UIImageView!
    var label: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        createElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        createElements()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
        
    }

    private func createElements() {
        self.selectionStyle = .none
        
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 10
        
        addSubview(horizontalStack)
        
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            horizontalStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            horizontalStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            horizontalStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 5)
        ])
        
        let imageView = UIImageView()
        self.elementImageView = imageView
        horizontalStack.addArrangedSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
     
        let label = UILabel()
        self.label = label
        
        horizontalStack.addArrangedSubview(label)
    }
}
