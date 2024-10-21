//
//  PaddingFormViewController.swift
//  Hookah_workers
//
//  Created by Karen Khachatryan on 21.10.24.
//

import UIKit
import Combine

class PaddingFormViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var flavorsTableView: UITableView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var strengthTextField: BaseTextField!
    @IBOutlet weak var descriptionTextField: BaseTextField!
    @IBOutlet weak var priceTextField: PricesTextField!
    @IBOutlet weak var tasteTextField: BaseTextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: BaseButton!
    private let viewModel = PaddingFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    func setupUI() {
        setNavigationBar(title: "Add padding")
        titleLabels.forEach({ $0.font = .montserratMedium(size: 21) })
        saveButton.titleLabel?.font = .montserratBold(size: 16)
        cancelButton.titleLabel?.font = .montserratMedium(size: 16)
        strengthTextField.delegate = self
        descriptionTextField.delegate = self
        priceTextField.baseDelegate = self
        tasteTextField.delegate = self
        flavorsTableView.delegate = self
        flavorsTableView.dataSource = self
        flavorsTableView.register(UINib(nibName: "FlavorTableViewCell", bundle: nil), forCellReuseIdentifier: "FlavorTableViewCell")
        flavorsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        registerKeyboardNotifications()
        saveButton.addShadow()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newSize = change?[.newKey] as? CGSize {
                updateTableViewHeight(newSize: newSize)
            }
        }
    }
    
    private func updateTableViewHeight(newSize: CGSize) {
        tableViewHeightConst.constant = newSize.height
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func subscribe() {
        viewModel.$paddingModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] paddingModel in
                guard let self = self else { return }
                self.saveButton.isEnabled = (paddingModel.fillingDescription.checkValidation() && paddingModel.price.checkValidation() && paddingModel.strength.checkValidation() && paddingModel.taste.checkValidation()) && (paddingModel.flavors.contains(where: { !$0.isEmpty }))
                self.strengthTextField.text = paddingModel.strength
                self.descriptionTextField.text = paddingModel.fillingDescription
                self.priceTextField.text = paddingModel.price
                self.tasteTextField.text = paddingModel.taste
                if (paddingModel.flavors.count) != viewModel.previousFlavorsCount {
                    self.flavorsTableView.reloadData()
                    viewModel.previousFlavorsCount = paddingModel.flavors.count
                }
            }
            .store(in: &cancellables)
    }
    
    @objc func addFlavor() {
        viewModel.addFlavor()
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        handleTap()
    }
    
    @IBAction func clickedSave(_ sender: Any) {
        viewModel.save { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func clickedCancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        viewModel.clear()
    }
}

extension PaddingFormViewController: UITextFieldDelegate, PriceTextFielddDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case strengthTextField:
            viewModel.paddingModel.strength = textField.text
        case descriptionTextField:
            viewModel.paddingModel.fillingDescription = textField.text
        case priceTextField:
            viewModel.paddingModel.price = textField.text
        case tasteTextField:
            viewModel.paddingModel.taste = textField.text
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == priceTextField, let value = textField.text, !value.isEmpty {
            priceTextField.text! += "$"
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let value = textField.text, !value.isEmpty && value.last == "$" else { return }
        if textField == priceTextField {
            priceTextField.text?.removeLast()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == priceTextField {
            return priceTextField.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        }
        return true
    }
}

extension PaddingFormViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.paddingModel.flavors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlavorTableViewCell", for: indexPath) as! FlavorTableViewCell
        cell.setupData(flavor: viewModel.paddingModel.flavors[indexPath.row], index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 55))
        let addFlavorButton = UIButton(type: .custom)
        addFlavorButton.setImage(UIImage.addButton, for: .normal)
        addFlavorButton.addTarget(self, action: #selector(addFlavor), for: .touchUpInside)
        addFlavorButton.frame = CGRect(x: (footerView.frame.width - 34) / 2, y: 20, width: 34, height: 34)
        footerView.addSubview(addFlavorButton)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        55
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension PaddingFormViewController {
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(PaddingFormViewController.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                scrollView.contentInset = .zero
            } else {
                let height: CGFloat = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)!.size.height
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}

