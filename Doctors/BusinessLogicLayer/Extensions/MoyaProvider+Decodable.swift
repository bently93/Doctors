//
// Created by N.Leontiev on 03.11.2019.
// Copyright (c) 2019 bently_93.com. All rights reserved.
//

import Foundation
import Moya
import RxSwift

extension MoyaProvider {
    func request<Type: Decodable>(target: Target, keyPath: String? = nil) -> Single<Type> {
        return Single.create { single in
            self.request(target, callbackQueue: .global(qos: .background)) { result in
                switch result {
                case .success(let response):
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let classes = try response.map(Type.self, atKeyPath: keyPath, using: decoder, failsOnEmptyData: false)
                        single(.success(classes))
                    } catch let error {
                        if let error = error as? MoyaError {
                            let apiError = self.errorMessageForStatusCode(error: error)
                            single(.error(apiError))
                            let body = try? error.response?.mapString()
                            print("response throw error: \(error), body: \(body), for \(Type.self)")
                        } else {
                            single(.error(APIError.badRequest))
                        }
                    }
                case .failure(let error):
                    let error = self.errorMessageForStatusCode(error: error)
                    print("\(error.localizedDescription) for \(Type.self)")
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    func errorMessageForStatusCode(error: MoyaError) -> APIError {
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
