//
//  String.swift
//  Hookah_workers
//
//  Created by Karen Khachatryan on 22.10.24.
//

import Foundation

extension String? {
    func checkValidation() -> Bool {
        guard let self = self else { return false }
        return !self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
