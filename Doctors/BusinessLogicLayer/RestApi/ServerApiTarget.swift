//
// Created by N.Leontiev on 03.11.2019.
// Copyright (c) 2019 bently_93.com. All rights reserved.
//

import Foundation
import Moya

enum ServerAPITarget {
    case speciality
    case doctors(specId: Int)
}

extension ServerAPITarget: TargetType {

    var baseURL: URL {
        return URL(string: "https://api.docdoc.ru/public/rest/1.0.9")!
    }

    var path: String {
        switch self {
        case .speciality:
            return "/speciality/top/deti/0/count/10/cityId/1"
        case .doctors(let specId):
            return "/doctor/list/start/0/count/0/city/1/speciality/\(specId)/type/landing/stations/111/near/extra/order/price/deti/0/na_dom/0"
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