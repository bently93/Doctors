//
// Created by N.Leontiev on 03.11.2019.
// Copyright (c) 2019 bently_93.com. All rights reserved.
//

import Foundation
import EasyDi

class ServicesAssembly: Assembly{
    private lazy var repoAssembly: RepoAssembly = self.context.assembly()
    private lazy var apiAssembly: RestApiAssembly = self.context.assembly()

    var doctorsService: DoctorsServiceProtocol {
        return define(init: DoctorsService(doctorsDBRepo: self.repoAssembly.doctorsDBRepo,
                restApi: self.apiAssembly.restApi))
    }

}