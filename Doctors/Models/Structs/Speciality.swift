//
// Created by n.leontiev on 17.05.2018.
// Copyright (c) 2018 bently_93.com. All rights reserved.
//

import Foundation

struct Speciality: Decodable {
    var id = 0
    var name = ""
    var alias = ""

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case alias = "Alias"
    }
}
