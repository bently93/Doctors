//
//  ViewController.swift
//  Doctors
//
//  Created by n.leontiev on 17.05.2018.
//  Copyright © 2018 bently_93.com. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var viewModel: MainViewModelProtocol?
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = MainViewModel()

        self.setupBindings()
        self.setupTableView()

        refreshControl.backgroundColor = .white
        self.tableView.addSubview(refreshControl)

        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view, typically from a nib.
    }

    private func setupBindings() {
        self.viewModel?.isHiddenActivityIndicator.asObservable()
                .bind(to: self.activityIndicator.rx.isHidden)
                .disposed(by: self.disposeBag)
        self.viewModel?.isHiddenTableView.asObservable()
        .bind(to: self.tableView.rx.isHidden )
        .disposed(by: self.disposeBag)

        self.viewModel?.showError
                .subscribe(onNext: {
                    s in
                    self.showErrorMsg(message: s)
                }).disposed(by: self.disposeBag)

        self.viewModel?.isRefreshing.asObservable()
                .bind(to: self.refreshControl.rx.isRefreshing)
                .disposed(by: self.disposeBag)

        self.refreshControl.rx.controlEvent(.valueChanged)
                .bind(to: self.viewModel?.startRefreshing ?? PublishSubject())
                .disposed(by: self.disposeBag)
    }

    private func setupTableView() {
        self.viewModel?.specialityArray.asObservable()
                .bind(to: tableView.rx.items(cellIdentifier: "cell")) {
                    (row: Int, speciality: Speciality, cell: UITableViewCell) in
                    cell.textLabel?.text = speciality.name
                }
                .disposed(by: self.disposeBag)

        self.tableView.rx.modelSelected(Speciality.self)
                .subscribe(onNext: {
                    (speciality: Speciality) in
                    self.performSegue(withIdentifier: "showDoctors", sender: speciality)
                })
                .disposed(by: self.disposeBag)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let identifier = segue.identifier {
            switch identifier {
            case "showDoctors":
                if let vc = segue.destination as? DoctorsViewController,
                   let spec = sender as? Speciality {
                    vc.viewModel = DoctorsViewModel(speciality: spec)
                }
                break
            default:
                break
            }
        }

    }
}
