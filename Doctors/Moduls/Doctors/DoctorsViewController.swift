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
import RealmSwift

class DoctorsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyDoctorsView: UIView!

    var viewModel: DoctorsViewModelProtocol?
    var speciality: Speciality?

    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let speciality = self.speciality else {
            return assertionFailure()
        }
        DoctorsViewAssembly.instance().inject(into: self, speciality: speciality)

        self.setupBindings()
        self.setupTableView()

        refreshControl.backgroundColor = .white
        self.tableView.addSubview(refreshControl)
        self.tableView.tableFooterView = UIView()
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

        self.viewModel?.isRefreshing.asObservable()
                .bind(to: self.refreshControl.rx.isRefreshing)
                .disposed(by: self.disposeBag)

        self.refreshControl.rx.controlEvent(.valueChanged)
                .bind(to: self.viewModel?.startRefreshing ?? PublishSubject())
                .disposed(by: disposeBag)

        self.viewModel?.showError
                .subscribe(onNext: { [unowned self] errorMsg in
                    self.showErrorMsg(message: errorMsg)
                })
                .disposed(by: disposeBag)
    }

    private func setupTableView() {
        self.viewModel?.doctors.asObservable()
                .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: DoctorsTableViewCell.self)) {
                    (row: Int, doctor: Doctor, cell: DoctorsTableViewCell) in
                    cell.nameLabel.text = doctor.name
                    cell.decriptionLabel.text = doctor.descriptionInfo
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
