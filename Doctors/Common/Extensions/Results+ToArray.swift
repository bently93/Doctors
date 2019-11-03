//
// Created by n.leontiev on 17.05.2018.
// Copyright (c) 2018 bently_93.com. All rights reserved.
//

import Foundation
import RealmSwift

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0..<count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }

        return array
    }
}