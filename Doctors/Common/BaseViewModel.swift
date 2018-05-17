//
// Created by n.leontiev on 17.05.2018.
// Copyright (c) 2018 bently_93.com. All rights reserved.
//

import Foundation
import RxSwift

class BaseViewModel {
    internal let disposeBag = DisposeBag()

    internal func getErrorMsg(error: Error) -> String {
        var message = ""
        if let apiError = error as? APIError {
            message = apiError.localizedDescription
        } else {
            message = error.localizedDescription
        }
        return message
    }
}
