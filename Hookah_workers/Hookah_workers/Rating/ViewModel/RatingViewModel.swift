//
//  RatingViewModel.swift
//  Hookah_workers
//
//  Created by Karen Khachatryan on 22.10.24.
//

import Foundation

class RatingViewModel {
    static let shared = RatingViewModel()
    @Published var paddings: [PaddingModel] = []
    private var data: [PaddingModel] = []
    private var rating: Double?
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchPaddings { [weak self] data, error in
            guard let self = self else { return }
            self.data = data
            if let rating = rating {
                self.paddings = data.filter({ $0.rating == rating })
            } else {
                self.paddings = data
            }
        }
    }
    
    func filterByRating(rating: Double) {
        self.rating = rating
        self.paddings = data.filter({ $0.rating == rating })
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
        paddings = []
        data = []
        rating = nil
    }
}
