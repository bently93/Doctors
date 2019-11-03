//
// Created by N.Leontiev on 03.11.2019.
// Copyright (c) 2019 bently_93.com. All rights reserved.
//

import Foundation
import RealmSwift

protocol DoctorsDBRepositoryProtocol {
    /// Сохранить все специальности
    func saveSpeciality(array: [Speciality])

    /// Получить все специальности с БД
    func getAllSpeciality()->[Speciality]

    /// Сохранить докторов для специальности
    func saveDoctors(array: [Doctor], specId: Int)

    /// Получить список докторов для специальности
    func getAllDoctor(specId: Int)->[Doctor]
}

class DoctorsDBRepository: DoctorsDBRepositoryProtocol {

    // MARK: - Private properties
    private let realmConfig: Realm.Configuration
    private let realm: Realm

    // MARK: - Initialization
    init(realmConfig: Realm.Configuration) {
        self.realmConfig =  realmConfig

        self.realm = try! Realm(configuration: realmConfig)
        defer {
            realm.invalidate()
        }
    }
}

// MARK: - Override functions
extension DoctorsDBRepository {
    func saveSpeciality(array: [Speciality]) {
        do {
            let realm = try Realm(configuration: self.realmConfig)
            defer {
                realm.invalidate()
            }

            try realm.write {
                let allSpec = realm.objects(SpecialityObject.self)
                realm.delete(allSpec)
                realm.add(self.toList(array: array))
            }
        } catch let error {
            print("saveSpecialityDB throw error: \(error)")
        }
    }

    func getAllSpeciality()->[Speciality]{
        return realm.objects(SpecialityObject.self).toArray()
    }

    func saveDoctors(array: [Doctor], specId: Int){
        do{
            let realm = try Realm(configuration: self.realmConfig)
            defer {
                realm.invalidate()
            }

            try realm.write {
                let doctorsForSpec = realm.objects(DoctorObject.self).filter("specId=%@", specId)
                realm.delete(doctorsForSpec)
                realm.add(self.toList(array: array))
            }
        }
        catch let error {
            print("saveSpecialityDB throw error: \(error)")
        }
    }

    func getAllDoctor(specId: Int)->[Doctor]{
        return realm.objects(DoctorObject.self)
                .filter("specId=%@", specId).toArray()
    }
}

// MARK: - Private functions
extension DoctorsDBRepository {
   private func toList<T: Persistable>(array: [T]) -> List<T.ManagedObject> {
        let list: List<T.ManagedObject> = List()
        array.forEach { item in
            list.append(item.managedObject())
        }
        return list
    }
}