//
// Created by n.leontiev on 17.05.2018.
// Copyright (c) 2018 bently_93.com. All rights reserved.
//

import Foundation
import RxSwift

protocol MainViewModelProtocol {
    var specialityArray: Variable<Array<Speciality>> { get }
    var isHiddenActivityIndicator: Variable<Bool> { get }


    var showError: PublishSubject<String> { get }
}

class MainViewModel: MainViewModelProtocol {
    private(set) var specialityArray: Variable<Array<Speciality>> = Variable(Array<Speciality>())
    private(set) var isHiddenActivityIndicator: Variable<Bool> = Variable(false)
    private(set) var showError: PublishSubject<String> = PublishSubject()

    private let restApi: RestApiProtocol

    init(restApi: RestApiProtocol = RestApi()) {
        self.restApi = restApi

        self.getData()
    }

    private func getData() {
        restApi.getSpeciality().subscribe(onNext: {
            array in
            self.specialityArray.value = array
            self.isHiddenActivityIndicator.value = true
        }, onError: {
            error in
            let errorMsg = self.getErrorMsg(error: error)
            self.showError.onNext(errorMsg)
            self.isHiddenActivityIndicator.value = true
        })
    }

    private func getErrorMsg(error: Error) -> String {
        var message = ""
        if let apiError = error as? APIError {
            message = apiError.localizedDescription
        } else {
            message = error.localizedDescription
        }
        return message
    }
}
