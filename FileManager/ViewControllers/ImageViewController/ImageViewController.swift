//
//  ImageViewController.swift
//  FileManager
//
//  Created by Oleshkevich Artem on 7.06.22.
//

import UIKit

class ImageViewController: UIViewController {
    
    var imageURL: URL!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpScrollView()
        setUpImage(imageURL)
    }
    private func setUpScrollView() {
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    func setUpImage(_ url: URL) {
        guard let data = try? Data(contentsOf: imageURL) else {
            return
        }
        self.imageView.image = UIImage(data: data)
    }
}
