//
// Created by n.leontiev on 17.05.2018.
// Copyright (c) 2018 bently_93.com. All rights reserved.
//

import Foundation

class Doctor {
    var id = 0
    var name = ""
    var description = ""

    func jsonToObject(json: NSDictionary) {
        self.id = json["Id"] as? Int ?? 0
        self.name = json["Name"] as? String ?? ""
        self.description = json["Description"] as? String ?? ""
    }
}