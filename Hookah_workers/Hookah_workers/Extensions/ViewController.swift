//
//  ViewController.swift
//  Hookah_workers
//
//  Created by Karen Khachatryan on 21.10.24.
//

import UIKit

extension UIViewController {
    func setNavigationBar(title: String, setButtons: Bool = true) {
        if setButtons {
            let backButton = UIButton(type: .custom)
            backButton.setImage(UIImage.back, for: .normal)
            backButton.imageView?.contentMode = .scaleAspectFit
            backButton.addTarget(self, action: #selector(clickedBack), for: .touchUpInside)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
            
            let menuButton = UIButton(type: .custom)
            menuButton.setImage(UIImage.menu, for: .normal)
            menuButton.addTarget(self, action: #selector(clickedMenu), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .baseDark
        titleLabel.font = .montserratExtraBold(size: 27)
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
    }
    
    func setNaviagtionBackButton(image: UIImage = .back) {
        let backButton = UIButton(type: .custom)
        backButton.setImage(image, for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.addTarget(self, action: #selector(clickedBack), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func setNaviagtionMenuButton() {
        let menuButton = UIButton(type: .custom)
        menuButton.setImage(UIImage.menu, for: .normal)
        menuButton.addTarget(self, action: #selector(clickedMenu), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
    }
    
    @objc func clickedBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func clickedMenu() {
        if let menuVC = navigationController?.viewControllers.first(where: { $0 is MenuViewController }) {
            self.navigationController?.popToViewController(menuVC, animated: true)
        } else if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let menuVC = UIStoryboard(name: "Menu", bundle: .main).instantiateViewController(identifier: "NavigationViewController")
            sceneDelegate.window?.rootViewController = menuVC
        }
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    func pushViewController<T: UIViewController>(_ viewControllerType: T.Type, animated: Bool = true) {
        let nibName = String(describing: viewControllerType)
        let viewController = T(nibName: nibName, bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view // Your source view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(alertController, animated: true, completion: nil)
    }
}

