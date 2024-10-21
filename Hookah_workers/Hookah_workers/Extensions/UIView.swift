//
//  UIView.swift
//  Hookah_workers
//
//  Created by Karen Khachatryan on 22.10.24.
//

import UIKit
extension UIView {
    func addShadow(color: UIColor = UIColor.black.withAlphaComponent(1),
                   offset: CGSize = CGSize(width: 0, height: 4),
                   radius: CGFloat = 4,
                   opacity: Float = 1.0) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
}

