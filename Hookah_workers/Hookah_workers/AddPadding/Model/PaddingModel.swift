//
//  PaddingModel.swift
//  Hookah_workers
//
//  Created by Karen Khachatryan on 22.10.24.
//

import Foundation

struct PaddingModel {
    var id: UUID?
    var strength: String?
    var fillingDescription: String?
    var price: String?
    var taste: String?
    var flavors: [String] = [""]
    var rating: Double = 0
}
