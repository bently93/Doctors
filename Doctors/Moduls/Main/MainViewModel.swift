//
// Created by n.leontiev on 17.05.2018.
// Copyright (c) 2018 bently_93.com. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

protocol MainViewModelProtocol {
    var specialityArray: Variable<Array<Speciality>> { get }
    var isHiddenActivityIndicator: Variable<Bool> { get }
    var isHiddenTableView: Variable<Bool> { get }
    var isRefreshing: Variable<Bool> { get }


    var showError: PublishSubject<String> { get }
    var reloadData: PublishSubject<Void> { get }
    var startRefreshing: PublishSubject<Void> { get }

}

class MainViewModel: BaseViewModel, MainViewModelProtocol  {
    private(set) var specialityArray: Variable<Array<Speciality>> = Variable(Array<Speciality>())
    private(set) var isHiddenActivityIndicator: Variable<Bool> = Variable(false)
    private(set) var isHiddenTableView: Variable<Bool> = Variable(true)
    private(set) var isRefreshing: Variable<Bool> = Variable(false)

    private(set) var showError: PublishSubject<String> = PublishSubject()
    private(set) var reloadData: PublishSubject<Void> = PublishSubject()
    private(set) var startRefreshing: PublishSubject<Void> = PublishSubject()

    private let restApi: RestApiProtocol
    private let realm: Realm = try! Realm()

    init(restApi: RestApiProtocol = RestApi()) {
        self.restApi = restApi

        super.init()

        self.updateData()

        self.reloadData.subscribe { void in
            self.getDataFromServer()
        }.disposed(by: self.disposeBag)

        self.startRefreshing.subscribe {
            void in
            self.getDataFromServer()
            self.isRefreshing.value = true
         }
    }

    private func updateData(){
        let allSpec = getAllSpecialityDB()
        if allSpec.isEmpty {
            self.getDataFromServer()
        } else {
            self.specialityArray.value = allSpec.toArray(ofType: Speciality.self)
            self.isHiddenActivityIndicator.value = true
            self.isHiddenTableView.value = false
        }
    }

    private func getDataFromServer() {
        restApi.getSpeciality().subscribe(onNext: {
            array in
            self.specialityArray.value = array
            self.isHiddenActivityIndicator.value = true
            self.isHiddenTableView.value = false
            self.isRefreshing.value = false
            self.saveSpecialityDB(array: array)
        }, onError: {
            error in
            let errorMsg = self.getErrorMsg(error: error)
            self.showError.onNext(errorMsg)
            self.isHiddenActivityIndicator.value = true
            self.isRefreshing.value = false
        }).disposed(by: self.disposeBag)
    }

    private func saveSpecialityDB(array: Array<Speciality>) {
        do {
            try realm.write {
                let all = getAllSpecialityDB()
                realm.delete(all)
                realm.add(array)
            }
        } catch {
        }
    }

    private func getAllSpecialityDB()->Results<Speciality>{
        return realm.objects(Speciality.self)
    }
}
