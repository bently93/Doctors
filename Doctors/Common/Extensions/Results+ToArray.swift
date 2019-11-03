//
// Created by n.leontiev on 17.05.2018.
// Copyright (c) 2018 bently_93.com. All rights reserved.
//

import Foundation
import RealmSwift

extension Results {
    func toArray<T: Persistable>() -> [T] where Element == T.ManagedObject {
        var array: [T] = []
        self.forEach { object in
            array.append(T.init(managedObject: object))
        }
        return array
    }
}