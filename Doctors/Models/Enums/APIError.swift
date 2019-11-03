//
// Created by N.Leontiev on 03.11.2019.
// Copyright (c) 2019 bently_93.com. All rights reserved.
//

import Foundation

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