//
// Created by n.leontiev on 17.05.2018.
// Copyright (c) 2018 bently_93.com. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol RestApiProtocol {
    func getSpeciality() -> Observable<Array<Speciality>>
    func getDoctors(startPage: Int, count: Int, specId: Int) -> Observable<Array<Doctor>>
}

class RestApi: RestApiProtocol {
    private let baseUrl = "https://api.docdoc.ru/public/rest/1.0.9"
    private let apiSpeciality: String

    init() {
        apiSpeciality = "\(baseUrl)/speciality/top/deti/0/count/10/cityId/1"
    }

    private func getApiDoctorsWithParam(startPage: Int, count: Int, specId: Int) -> String {
        return "\(baseUrl)/doctor/list/start/\(startPage)/count/\(count)/city/1/speciality/\(specId)/type/landing/stations/111/near/extra/order/price/deti/0/na_dom/0"
    }

    func getSpeciality() -> Observable<Array<Speciality>> {
        return Observable.create { observer in
            Alamofire.request(self.apiSpeciality, method: .get)
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
                                        let spec: Speciality = Speciality()
                                        spec.jsonToObject(json: jsonSpec)
                                        array.append(spec)
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

    func getDoctors(startPage: Int, count: Int, specId: Int) -> Observable<Array<Doctor>> {
        let api = getApiDoctorsWithParam(startPage: startPage, count: count, specId: specId)

        return Observable.create { observer in
            Alamofire.request(api, method: .get)
                    .authenticate(user: "partner.13703", password: "ZZdFmtJD")
                    .validate()
                    .responseJSON() {
                        response in
                        switch response.result {
                        case .success:
                            if let json = response.result.value as? NSDictionary,
                               let jsonArray = json["DoctorList"] as? NSArray {
                                var array = Array<Doctor>()
                                jsonArray.forEach {
                                    v in
                                    if let jsonDoc = v as? NSDictionary {
                                        let doctor = Doctor()
                                        doctor.jsonToObject(json: jsonDoc)
                                        array.append(doctor)
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
