//
//  StuffingsViewModel.swift
//  Hookah_workers
//
//  Created by Karen Khachatryan on 22.10.24.
//

import Foundation

class StuffingsViewModel {
    static let shared = StuffingsViewModel()
    @Published var stuffings: [PaddingModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchPaddings { [weak self] paddings, error in
            guard let self = self else { return }
            self.stuffings = paddings
        }
    }
    
    func setRatingByID(rating: Double, id: UUID, completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.updatePaddingRating(by: id, newRating: rating) { error in
            completion(error)
        }
    }
    
    func removePadding(padding: PaddingModel, completion: @escaping (Error?) -> Void) {
        guard let id = padding.id else { return }
        CoreDataManager.shared.removePadding(by: id) { error in
            completion(error)
        }
    }
    
    func clear() {
        stuffings = []
    }
}
