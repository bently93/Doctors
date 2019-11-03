//
// Created by n.leontiev on 17.05.2018.
// Copyright (c) 2018 bently_93.com. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

protocol DoctorsViewModelProtocol {
    var doctors: Variable<Array<Doctor>> { get }

    var isHiddenTableView: Variable<Bool> { get }
    var isHiddenActivityIndicator: Variable<Bool> { get }
    var isHiddenEmptyDoctors: Variable<Bool> { get }
    var isRefreshing: Variable<Bool> { get }

    var showError: PublishSubject<String> { get }
    var reloadData: PublishSubject<Void> { get }
    var startRefreshing: PublishSubject<Void> { get }
}

class DoctorsViewModel: BaseViewModel, DoctorsViewModelProtocol {
    private(set) var doctors: Variable<Array<Doctor>> = Variable(Array<Doctor>())
    private(set) var isHiddenTableView: Variable<Bool> = Variable(true)
    private(set) var isHiddenActivityIndicator: Variable<Bool> = Variable(false)
    private(set) var isHiddenEmptyDoctors: Variable<Bool> = Variable(true)
    private(set) var isRefreshing: Variable<Bool> = Variable(false)

    private(set) var showError: PublishSubject<String> = PublishSubject()
    private(set) var reloadData: PublishSubject<Void> = PublishSubject()
    private(set) var startRefreshing: PublishSubject<Void> = PublishSubject()

    private let speciality: Speciality
    private let doctorsService: DoctorsServiceProtocol

    init(speciality: Speciality, doctorsService: DoctorsServiceProtocol) {
        self.speciality = speciality
        self.doctorsService = doctorsService

        super.init()

        self.updateData()
        self.setupBindings()
    }

    private func setupBindings() {
        self.reloadData.subscribe { [unowned self] in
                    self.getDataFromServer()
                }
                .disposed(by: self.disposeBag)

        self.startRefreshing.subscribe { [unowned self] in
                    self.getDataFromServer()
                    self.isRefreshing.value = true
                }
                .disposed(by: self.disposeBag)

    }

    private func updateData() {
        let allDoctor = self.doctorsService.getDoctorsFromCache(specId: self.speciality.id)
        if allDoctor.isEmpty {
            getDataFromServer()
        } else {
            self.doctors.value = allDoctor
            self.isHiddenActivityIndicator.value = true
            self.isHiddenTableView.value = false
        }
    }

    private func getDataFromServer() {
        self.doctorsService.getDoctors(specId: self.speciality.id)
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { [unowned self] array in
                    self.isHiddenEmptyDoctors.value = !array.isEmpty
                    self.isHiddenTableView.value = array.isEmpty

                    self.doctors.value = array
                    self.isHiddenActivityIndicator.value = true
                    self.isRefreshing.value = false
                }, onError: { [unowned self] error in
                    let errorMsg = self.getErrorMsg(error: error)
                    self.showError.onNext(errorMsg)
                    self.isHiddenActivityIndicator.value = true
                    self.isRefreshing.value = false
                })
                .disposed(by: self.disposeBag)
    }
}
