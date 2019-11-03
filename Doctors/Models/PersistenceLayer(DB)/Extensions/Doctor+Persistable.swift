//
// Created by N.Leontiev on 03.11.2019.
// Copyright (c) 2019 bently_93.com. All rights reserved.
//

import Foundation

extension Doctor: Persistable {
    init(managedObject: DoctorObject) {
        self.id = managedObject.id
        self.name = managedObject.name
        self.descriptionInfo = managedObject.descriptionInfo
        self.specId = managedObject.specId
    }

    func managedObject() -> DoctorObject {
        let managedObject = DoctorObject()
        managedObject.id = self.id
        managedObject.name = name
        managedObject.descriptionInfo = descriptionInfo
        managedObject.specId = specId
        return managedObject
    }
}