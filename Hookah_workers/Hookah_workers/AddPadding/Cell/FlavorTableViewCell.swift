//
//  FlavorTableViewCell.swift
//  Hookah_workers
//
//  Created by Karen Khachatryan on 21.10.24.
//

import UIKit

class FlavorTableViewCell: UITableViewCell {

    @IBOutlet weak var flavorTextField: BaseTextField!
    private var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        flavorTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        index = 0
    }
    
    func setupData(flavor: String, index: Int) {
        self.index = index
        flavorTextField.text = flavor
    }
}

extension FlavorTableViewCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        PaddingFormViewModel.shared.paddingModel.flavors[index] = textField.text ?? ""
    }
}
