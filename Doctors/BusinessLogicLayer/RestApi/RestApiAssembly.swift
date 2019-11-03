//
// Created by N.Leontiev on 03.11.2019.
// Copyright (c) 2019 bently_93.com. All rights reserved.
//

import Foundation
import EasyDi

class RestApiAssembly: Assembly {
    var restApi: RestApiProtocol {
        return define(init: RestApi())
    }
}
