//
//  ImageViewController.swift
//  FileManager
//
//  Created by Oleshkevich Artem on 7.06.22.
//

import UIKit

class ImageViewController: UIViewController {
    
    var imageURL: URL?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScrollView()
        setUpImage()
    }
    private func setUpScrollView() {
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func setUpImage() {
        if let imageURL = imageURL {
            imageView.image = UIImage.init(contentsOfFile: imageURL.path)
        }
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
