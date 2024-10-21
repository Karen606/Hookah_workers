//
//  Font.swift
//  Hookah_workers
//
//  Created by Karen Khachatryan on 21.10.24.
//

import Foundation
import UIKit

extension UIFont {
    static func montserratExtraBold(size: CFloat) -> UIFont? {
        return UIFont(name: "Montserrat-ExtraBold", size: CGFloat(size))
    }
    
    static func montserratBold(size: CFloat) -> UIFont? {
        return UIFont(name: "Montserrat-Bold", size: CGFloat(size))
    }
    
    static func montserratSemiBold(size: CFloat) -> UIFont? {
        return UIFont(name: "Montserrat-SemiBold", size: CGFloat(size))
    }
    
    static func montserratMedium(size: CFloat) -> UIFont? {
        return UIFont(name: "Montserrat-Medium", size: CGFloat(size))
    }
    
    static func montserratRegular(size: CFloat) -> UIFont? {
        return UIFont(name: "Montserrat-Regular", size: CGFloat(size))
    }
}
