//
// Created by N.Leontiev on 03.11.2019.
// Copyright (c) 2019 bently_93.com. All rights reserved.
//

import Foundation
import EasyDi
import RealmSwift

class RepoAssembly: Assembly {
    private var realmConfig: Realm.Configuration {
        return define(init: Realm.Configuration.defaultConfiguration)
    }

    var doctorsDBRepo: DoctorsDBRepositoryProtocol {
        return define(init: DoctorsDBRepository(realmConfig: self.realmConfig))
    }
}
