//
//  ImageViewController + UIScrollViewDelegate.swift
//  FileManager
//
//  Created by Oleshkevich Artem on 1.07.22.
//

import UIKit

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

