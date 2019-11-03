//
// Created by n.leontiev on 17.05.2018.
// Copyright (c) 2018 bently_93.com. All rights reserved.
//

import Foundation
import RealmSwift

struct Doctor: Decodable {
    var id = 0
    var name = ""
    var descriptionInfo = ""
    var specId = 0

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case descriptionInfo = "Description"
    }
}
