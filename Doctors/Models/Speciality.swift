//
// Created by n.leontiev on 17.05.2018.
// Copyright (c) 2018 bently_93.com. All rights reserved.
//

import Foundation
import RealmSwift

class Speciality: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var alias = ""

    func jsonToObject(json: NSDictionary) {
        if let idStr = json["Id"] as? NSString {
            self.id = idStr.integerValue
        }
        self.name = json["Name"] as? String ?? ""
        self.alias = json["Alias"] as? String ?? ""
    }
}
