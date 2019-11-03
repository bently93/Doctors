//
// Created by N.Leontiev on 03.11.2019.
// Copyright (c) 2019 bently_93.com. All rights reserved.
//

import Foundation

extension Speciality: Persistable {
    init(managedObject: SpecialityObject) {
        self.id = managedObject.id
        self.name = managedObject.name
        self.alias = managedObject.alias
    }

    func managedObject() -> SpecialityObject {
        let managedObject = SpecialityObject()
        managedObject.id = self.id
        managedObject.name = name
        managedObject.alias = alias
        return managedObject
    }
}