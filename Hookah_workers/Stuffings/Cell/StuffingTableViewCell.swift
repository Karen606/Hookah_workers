//
//  StuffingTableViewCell.swift
//  Hookah_workers
//
//  Created by Karen Khachatryan on 22.10.24.
//

import UIKit
import Cosmos

protocol StuffingTableViewCellDelegate: AnyObject {
    func setRating(value: Double, id: UUID)
}

class StuffingTableViewCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var flavorsLabel: UILabel!
    @IBOutlet weak var tasteLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var ratingLabel: UILabel!
    var padding: PaddingModel?
    weak var delegate: StuffingTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 12
        bgView.layer.borderColor = UIColor.black.cgColor
        bgView.layer.borderWidth = 2
        strengthLabel.layer.masksToBounds = true
        strengthLabel.font = .montserratExtraBold(size: 12)
        flavorsLabel.font = .montserratExtraBold(size: 20)
        tasteLabel.font = .montserratExtraBold(size: 12)
        ratingLabel.font = .montserratExtraBold(size: 17)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCosmosViewTap(_:)))
        ratingView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleCosmosViewTap(_ sender: UITapGestureRecognizer) {
        if let cosmosView = sender.view as? CosmosView {
            let location = sender.location(in: cosmosView)
            let rating = Double(Int(Double(location.x / ratingView.bounds.width) * Double(ratingView.settings.totalStars) + 1))
            ratingView.rating = rating
            ratingLabel.text = "\(Int(rating))"
            if let id = padding?.id {
                self.delegate?.setRating(value: rating, id: id)
            }
        }
    }
    
    override func prepareForReuse() {
        padding = nil
        delegate = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupData(padding: PaddingModel) {
        self.padding = padding
        var flavors = padding.flavors
        flavors.removeAll(where: { $0 == "" })
        flavorsLabel.text = flavors.joined(separator: " + ")
        tasteLabel.text = padding.taste
        strengthLabel.text = padding.strength
        ratingView.rating = padding.rating
        ratingLabel.text = "\(Int(padding.rating))"
    }
}
