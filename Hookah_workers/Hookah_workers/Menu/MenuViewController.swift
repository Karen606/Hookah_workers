//
//  ViewController.swift
//  Hookah_workers
//
//  Created by Karen Khachatryan on 21.10.24.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet var sectionsButton: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionsButton.forEach({ $0.titleLabel?.font = .montserratExtraBold(size: 21) })
    }

    @IBAction func clickedMyStuffing(_ sender: UIButton) {
        self.pushViewController(StuffingsViewController.self)
    }
    
    @IBAction func clickedAddPadding(_ sender: UIButton) {
        self.pushViewController(PaddingFormViewController.self)
    }
    
    @IBAction func clickedRating(_ sender: UIButton) {
//        self.pushViewController(CoctailsViewController.self)
    }
    
    @IBAction func clickedSetting(_ sender: UIButton) {
        self.pushViewController(SettingViewController.self)
    }}

