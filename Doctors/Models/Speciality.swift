//
// Created by n.leontiev on 17.05.2018.
// Copyright (c) 2018 bently_93.com. All rights reserved.
//

import Foundation
import RealmSwift

class Speciality: Object, Decodable {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var alias = ""
    
    convenience init(id: Int, name: String, alias: String){
        self.init()
        self.id = id
        self.name = name
        self.alias = alias
    }

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case alias = "Alias"
    }

    required convenience init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let alias = try container.decode(String.self, forKey: .alias)
        
        self.init(id: Int(id) ?? 0, name: name, alias: alias)
    }
}
