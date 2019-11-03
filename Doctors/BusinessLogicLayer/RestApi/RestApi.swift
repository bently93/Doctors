//
// Created by n.leontiev on 17.05.2018.
// Copyright (c) 2018 bently_93.com. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import Moya

enum ServerAPI {
    case speciality
    case doctors(startPage: Int, count: Int, specId: Int)
}

extension ServerAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.docdoc.ru/public/rest/1.0.9")!
    }
    
    var path: String {
        switch self {
        case .speciality:
            return "/speciality/top/deti/0/count/10/cityId/1"
        case .doctors(let startPage, let count, let specId):
            return "/doctor/list/start/\(startPage)/count/\(count)/city/1/speciality/\(specId)/type/landing/stations/111/near/extra/order/price/deti/0/na_dom/0"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}


protocol RestApiProtocol {
    func getSpeciality() -> Observable<Array<Speciality>>
    func getDoctors(startPage: Int, count: Int, specId: Int) -> Observable<Array<Doctor>>
}

class RestApi: RestApiProtocol {
    private let provider: MoyaProvider<ServerAPI>
    
    init() {
        let credentialsPlugin = CredentialsPlugin { _ -> URLCredential? in
             return URLCredential(user: "partner.13703", password: "ZZdFmtJD", persistence: .none)
        }
        self.provider = MoyaProvider<ServerAPI>(plugins: [credentialsPlugin])
    }
    
   
    
    func getSpeciality() -> Observable<Array<Speciality>> {
        return providerRequest(target: .speciality, keyPath: "SpecList")
    }
    
    func getDoctors(startPage: Int, count: Int, specId: Int) -> Observable<Array<Doctor>> {
        return providerRequest(target: .doctors(startPage: startPage, count: count, specId: specId), keyPath: "DoctorList")
    }
    
    
    private func providerRequest<Type: Decodable>(target: ServerAPI, keyPath: String? = nil) -> Observable<Type> {
        return Observable.create { observer in
            self.provider.request(target) {
                result in
                switch result {
                case .success(let response):
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let classes = try response.map(Type.self, atKeyPath: keyPath, using: decoder, failsOnEmptyData: false)
                        observer.onNext(classes)
                    } catch let error {
                        print("\(error.localizedDescription)")
                        observer.onError(APIError.badRequest)
                    }
                case .failure(let error):
                    let error = self.errorMessageForStatusCode(error: error)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
   
    //handling error status code
    private func errorMessageForStatusCode(error: MoyaError) -> APIError {
        let apiError: APIError
        if let httpStatusCode = error.response?.statusCode {
            switch (httpStatusCode) {
            case 400:
                apiError = .badRequest
            case 401, 404, 501:
                apiError = .notFound
            case 500:
                apiError = .serverError
            default:
                apiError = .noInternetConnection
            }
        } else {
            apiError = .noInternetConnection
        }
        return apiError
    }
}

enum APIError: Error {
    case badRequest
    case notFound
    case serverError
    case noInternetConnection
    
    var localizedDescription: String {
        switch self {
        case .badRequest:
            return "Некорректные данные."
        case .notFound:
            return "Запрошенный ресурс не найден."
        case .serverError:
            return "Ошибка сервера"
        case .noInternetConnection:
            return "Вероятно, соединение с Интернетом прервано."
        }
    }
}
