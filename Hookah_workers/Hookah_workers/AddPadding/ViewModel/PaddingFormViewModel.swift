//
//  PaddingFormViewModel.swift
//  Hookah_workers
//
//  Created by Karen Khachatryan on 22.10.24.
//

import Foundation

class PaddingFormViewModel {
    static let shared = PaddingFormViewModel()
    @Published var paddingModel = PaddingModel()
    var previousFlavorsCount: Int = 0
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        paddingModel.flavors.removeAll(where: { !$0.checkValidation() })
        CoreDataManager.shared.savePadding(paddingModel: paddingModel) { error in
            completion(error)
        }
    }
    
    func addFlavor() {
        paddingModel.flavors.append("")
    }
    
    func clear() {
        paddingModel = PaddingModel()
        previousFlavorsCount = 0
    }
}
