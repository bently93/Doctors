//
// Created by n.leontiev on 17.05.2018.
// Copyright (c) 2018 bently_93.com. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import Moya

protocol RestApiProtocol {
    func getSpeciality() -> Single<[Speciality]>
    func getDoctors(specId: Int) -> Single<[Doctor]>
}

class RestApi: RestApiProtocol {
    private let provider: MoyaProvider<ServerAPITarget>

    init() {
        let credentialsPlugin = CredentialsPlugin { _ -> URLCredential? in
            return URLCredential(user: "partner.13703", password: "ZZdFmtJD", persistence: .none)
        }
        self.provider = MoyaProvider<ServerAPITarget>(plugins: [credentialsPlugin])
    }

    func getSpeciality() -> Single<[Speciality]> {
        return self.provider.request(target: .speciality, keyPath: "SpecList")
    }

    func getDoctors(specId: Int) -> Single<[Doctor]> {
        return self.provider.request(target: .doctors(specId: specId), keyPath: "DoctorList")
    }
}
