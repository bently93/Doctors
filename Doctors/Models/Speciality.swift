//
// Created by n.leontiev on 17.05.2018.
// Copyright (c) 2018 bently_93.com. All rights reserved.
//

import Foundation

class Speciality {
    var id = 0
    var name = ""
    var alias = ""


    init(json: NSDictionary){
        if let idStr = json["Id"] as? NSString {
            self.id = idStr.integerValue
        }
        self.name = json["Name"] as? String ?? ""
        self.alias = json["Alias"] as? String ?? ""
    }
}
