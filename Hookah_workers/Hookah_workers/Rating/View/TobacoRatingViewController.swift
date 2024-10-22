//
//  TobacoRatingViewController.swift
//  Hookah_workers
//
//  Created by Karen Khachatryan on 22.10.24.
//

import UIKit
import Cosmos
import Combine

class TobacoRatingViewController: UIViewController {
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var paddingsTableView: UITableView!
    private let viewModel = RatingViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
        ratingView.didFinishTouchingCosmos = { [weak self] rating in
            guard let self = self else { return }
            self.viewModel.filterByRating(rating: rating)
        }
    }
    
    func setupUI() {
        setNavigationBar(title: "Tobacco rating")
        paddingsTableView.delegate = self
        paddingsTableView.dataSource = self
        paddingsTableView.register(UINib(nibName: "StuffingTableViewCell", bundle: nil), forCellReuseIdentifier: "StuffingTableViewCell")
    }
    
    func subscribe() {
        viewModel.$paddings
            .receive(on: DispatchQueue.main)
            .sink { [weak self] paddings in
                guard let self = self else { return }
                self.paddingsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc func addPadding() {
        let paddingFormVC = PaddingFormViewController(nibName: "PaddingFormViewController", bundle: nil)
        paddingFormVC.complition = { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchData()
        }
        self.navigationController?.pushViewController(paddingFormVC, animated: true)
    }
    
    deinit {
        viewModel.clear()
    }
}

extension TobacoRatingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.paddings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StuffingTableViewCell", for: indexPath) as! StuffingTableViewCell
        cell.setupData(padding: viewModel.paddings[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 65))
        let addPaddingButton = UIButton(type: .custom)
        addPaddingButton.setImage(UIImage.addButton, for: .normal)
        addPaddingButton.imageView?.contentMode = .center
        addPaddingButton.addTarget(self, action: #selector(addPadding), for: .touchUpInside)
        addPaddingButton.frame = CGRect(x: (footerView.frame.width - 40) / 2, y: 20, width: 40, height: 40)
        footerView.addSubview(addPaddingButton)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let paddingFormVC = PaddingFormViewController(nibName: "PaddingFormViewController", bundle: nil)
        PaddingFormViewModel.shared.paddingModel = viewModel.paddings[indexPath.row]
        paddingFormVC.complition = { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchData()
        }
        self.navigationController?.pushViewController(paddingFormVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] (action, view, handler) in
            guard let self = self else { return }
            self.viewModel.removePadding(padding: self.viewModel.paddings[indexPath.row]) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.showErrorAlert(message: error.localizedDescription)
                } else {
                    self.viewModel.paddings.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    handler(true)
                    self.viewModel.fetchData()
                }
            }
            
        }
        deleteAction.backgroundColor = .white
        deleteAction.image = UIImage.removeIcon
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension TobacoRatingViewController: StuffingTableViewCellDelegate {
    func setRating(value: Double, id: UUID) {
        viewModel.setRatingByID(rating: value, id: id) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.viewModel.fetchData()
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.viewModel.fetchData()
            }
        }
    }
}
