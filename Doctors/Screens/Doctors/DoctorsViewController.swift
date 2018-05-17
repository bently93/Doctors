//
//  DoctorsViewController.swift
//  Doctors
//
//  Created by n.leontiev on 17.05.2018.
//  Copyright © 2018 bently_93.com. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DoctorsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyDoctorsView: UIView!

    var viewModel: DoctorsViewModelProtocol?
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupBindings()
        self.setupTableView()

        tableView.tableFooterView = UIView()
    }

    private func setupBindings() {
        self.viewModel?.isHiddenActivityIndicator
                .asObservable()
                .bind(to: self.activityIndicator.rx.isHidden)
                .disposed(by: self.disposeBag)

        self.viewModel?.isHiddenTableView
                .asObservable()
                .bind(to: self.tableView.rx.isHidden)
                .disposed(by: self.disposeBag)

        self.viewModel?.isHiddenEmptyDoctors
                .asObservable()
                .bind(to: self.emptyDoctorsView.rx.isHidden)
                .disposed(by: self.disposeBag)

        self.viewModel?.showError.subscribe(onNext: {
            errorMsg in
            self.showErrorMsg(message: errorMsg)
        })
    }

    private func setupTableView() {
        self.viewModel?.doctors.asObservable()
                .bind(to: tableView.rx.items(cellIdentifier: "cell")) {
                    (row: Int, doctor: Doctor, cell: UITableViewCell) in
                    cell.textLabel?.text = doctor.name
                    cell.detailTextLabel?.text = doctor.description
                }
                .disposed(by: disposeBag)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showErrorMsg(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default) {
            action in
            self.viewModel?.reloadData.onNext(())
        }
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
