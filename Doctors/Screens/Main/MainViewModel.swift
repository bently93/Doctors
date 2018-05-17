//
// Created by n.leontiev on 17.05.2018.
// Copyright (c) 2018 bently_93.com. All rights reserved.
//

import Foundation
import RxSwift

protocol MainViewModelProtocol {
    var specialityArray: Variable<Array<Speciality>> { get }
    var isHiddenActivityIndicator: Variable<Bool> { get }
    var isRefreshing: Variable<Bool> { get }


    var showError: PublishSubject<String> { get }
    var reloadData: PublishSubject<Void> { get }
    var startRefreshing: PublishSubject<Void> { get }

}

class MainViewModel: BaseViewModel, MainViewModelProtocol  {
    private(set) var specialityArray: Variable<Array<Speciality>> = Variable(Array<Speciality>())
    private(set) var isHiddenActivityIndicator: Variable<Bool> = Variable(false)
    private(set) var isRefreshing: Variable<Bool> = Variable(false)

    private(set) var showError: PublishSubject<String> = PublishSubject()
    private(set) var reloadData: PublishSubject<Void> = PublishSubject()
    private(set) var startRefreshing: PublishSubject<Void> = PublishSubject()

    private let restApi: RestApiProtocol

    init(restApi: RestApiProtocol = RestApi()) {
        self.restApi = restApi

        super.init()

        self.getData()
        self.reloadData.subscribe { void in
            self.getData()
        }.disposed(by: self.disposeBag)

        self.startRefreshing.subscribe {
            void in
            self.getData()
            self.isRefreshing.value = true
         }
    }

    private func getData() {
        restApi.getSpeciality().subscribe(onNext: {
            array in
            self.specialityArray.value = array
            self.isHiddenActivityIndicator.value = true
            self.isRefreshing.value = false
        }, onError: {
            error in
            let errorMsg = self.getErrorMsg(error: error)
            self.showError.onNext(errorMsg)
            self.isHiddenActivityIndicator.value = true
            self.isRefreshing.value = false
        }).disposed(by: self.disposeBag)
    }
}
