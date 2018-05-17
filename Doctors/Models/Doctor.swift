//
// Created by n.leontiev on 17.05.2018.
// Copyright (c) 2018 bently_93.com. All rights reserved.
//

import Foundation
import RealmSwift

class Doctor: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var descriptionInfo = ""
    @objc dynamic var specId = 0

    func jsonToObject(json: NSDictionary) {
        self.id = json["Id"] as? Int ?? 0
        self.name = json["Name"] as? String ?? ""
        self.descriptionInfo = json["Description"] as? String ?? ""
    }
}