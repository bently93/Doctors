//
// Created by N.Leontiev on 03.11.2019.
// Copyright (c) 2019 bently_93.com. All rights reserved.
//

import Foundation
import RxSwift


protocol DoctorsServiceProtocol {
    /// Получить список специальностей, полученный с сервера
    func getSpeciality() -> Single<[Speciality]>

    /// Получить список специальностей, полученный с кэша
    func getSpecialitiesFromCache() -> [Speciality]

    /// Получить список докторов для специальности
    func getDoctors(specId: Int) -> Single<[Doctor]>

    /// Получить список докторов для специальности, полученный с кэша
    func getDoctorsFromCache(specId: Int)->[Doctor]
}

class DoctorsService: DoctorsServiceProtocol {

    // MARK: - Properties
    private let doctorsDBRepo: DoctorsDBRepositoryProtocol
    private let restApi: RestApiProtocol

    // MARK: - Initialization
    init(doctorsDBRepo: DoctorsDBRepositoryProtocol,
         restApi: RestApiProtocol) {
        self.doctorsDBRepo = doctorsDBRepo
        self.restApi = restApi
    }
}

// MARK: - Override functions
extension DoctorsService {
    func getSpeciality() -> Single<[Speciality]> {
        return restApi.getSpeciality()
                .do(onSuccess: { [weak self] array in
                    self?.doctorsDBRepo.saveSpeciality(array: array)
                })
    }

    func getSpecialitiesFromCache() -> [Speciality] {
        return self.doctorsDBRepo.getAllSpeciality()
    }

    func getDoctors(specId: Int) -> Single<[Doctor]> {
        restApi.getDoctors(specId: specId)
                .map { doctors in
                    let mutableDoctors: [Doctor] = doctors.map { doctor in
                        var mutableDoctor = doctor
                        mutableDoctor.specId = specId
                        return mutableDoctor
                    }
                    self.doctorsDBRepo.saveDoctors(array: mutableDoctors, specId: specId)
                    return mutableDoctors
                }
    }

    func getDoctorsFromCache(specId: Int)->[Doctor] {
        return self.doctorsDBRepo.getAllDoctor(specId: specId)
    }
}

// MARK: - Private functions
extension DoctorsService {

}