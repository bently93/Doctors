//
// Created by n.leontiev on 17.05.2018.
// Copyright (c) 2018 bently_93.com. All rights reserved.
//

import Foundation
import RxSwift

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

class DoctorsViewModel: BaseViewModel, DoctorsViewModelProtocol  {
    private(set) var doctors: Variable<Array<Doctor>> = Variable(Array<Doctor>())
    private(set) var isHiddenTableView: Variable<Bool> = Variable(true)
    private(set) var isHiddenActivityIndicator: Variable<Bool> = Variable(false)
    private(set) var isHiddenEmptyDoctors: Variable<Bool> = Variable(true)
    private(set) var isRefreshing: Variable<Bool> = Variable(false)

    private(set) var showError: PublishSubject<String> = PublishSubject()
    private(set) var reloadData: PublishSubject<Void> = PublishSubject()
    private(set) var startRefreshing: PublishSubject<Void> = PublishSubject()

    private let restApi: RestApiProtocol
    private let speciality: Speciality

    init(speciality: Speciality, restApi: RestApiProtocol = RestApi()) {
        self.restApi = restApi
        self.speciality = speciality

        super.init()

        self.getData(startPage: 0)

        self.reloadData.subscribe { void in
            self.getData(startPage: 0)
        }.disposed(by: self.disposeBag)

        self.startRefreshing.subscribe {
            void in
            self.getData(startPage: 0)
            self.isRefreshing.value = true
        }
    }

    private func getData(startPage: Int, count: Int = 0) {
        restApi.getDoctors(startPage: startPage, count: count, specId: self.speciality.id)
                .subscribe(onNext: {
                    array in
                    self.isHiddenEmptyDoctors.value = !array.isEmpty
                    self.isHiddenTableView.value = array.isEmpty

                    self.doctors.value = array
                    self.isHiddenActivityIndicator.value = true
                    self.isRefreshing.value = false
                }, onError: {
                    (error: Error) in
                    let errorMsg = self.getErrorMsg(error: error)
                    self.showError.onNext(errorMsg)
                    self.isHiddenActivityIndicator.value = true
                    self.isRefreshing.value = false
                })
                .disposed(by: self.disposeBag)
    }
}