//
// Created by n.leontiev on 17.05.2018.
// Copyright (c) 2018 bently_93.com. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol RestApiProtocol {
    func getSpeciality() -> Observable<Array<Speciality>>
}

class RestApi: RestApiProtocol {
    private let baseUrl = "https://api.docdoc.ru/public/rest/1.0.9"
    private let urlSpeciality: String

    init() {
        urlSpeciality = "\(baseUrl)/speciality/top/deti/0/count/10/cityId/1"
    }

    func getSpeciality() -> Observable<Array<Speciality>> {
        return Observable.create { observer in
            Alamofire.request(self.urlSpeciality, method: .get)
                    .authenticate(user: "partner.13703", password: "ZZdFmtJD")
                    .validate()
                    .responseJSON() {
                        response in
                        switch response.result {
                        case .success:
                            if let json = response.result.value as? NSDictionary,
                               let jsonArray = json["SpecList"] as? NSArray {
                                var array = Array<Speciality>()
                                jsonArray.forEach {
                                    v in
                                    if let jsonSpec = v as? NSDictionary {
                                        array.append(Speciality(json: jsonSpec))
                                    }
                                 }

                                observer.onNext(array)
                            } else {
                                observer.onError(APIError.badRequest)
                            }
                            return
                        case .failure:
                            let error = self.errorMessageForStatusCode(response: response)
                            observer.onError(error)
                        }
                    }
            return Disposables.create()
        }
    }

    private func errorMessageForStatusCode(response: DataResponse<Any>) -> Error {
        let error: Error
        if let httpStatusCode = response.response?.statusCode {
            switch (httpStatusCode) {
            case 400:
                error = APIError.badRequest
            case 404:
                error = APIError.notFound
            case 500:
                error = APIError.serverError
            default:
                error = response.error ?? APIError.serverError
            }
        } else {
            error = response.error ?? APIError.serverError
        }
        return error
    }
}

enum APIError: Error {
    case badRequest
    case notFound
    case serverError

    var localizedDescription: String {
        switch self {
        case .badRequest:
            return "Некорректные данные."
        case .notFound:
            return "Запрошенный ресурс не найден."
        case .serverError:
            return "Ошибка сервера"
        default:
            return "Вероятно, соединение с Интернетом прервано."
        }
    }
}
