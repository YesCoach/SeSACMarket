//
//  RealmStorage.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/10.
//

import Foundation
import RealmSwift

final class RealmStorage {

    enum RealmError: Error {
        case invalidInitialize
    }

    static let shared = RealmStorage()

    private let realm = {
        try? Realm()
    }()

    private init() { }

}

extension RealmStorage {

    func checkSchemaVersion() {
        guard let realm else { return }
        do {
            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
            print("Schema Version: \(version)")
        } catch {
            print(error)
        }
    }

    // MARK: - CRUD

    func createData<T: Object>(data: T) {
        guard let realm else { return }
        do {
            try realm.write {
                realm.add(data)
                print("Realm Add Succeed")
            }
        } catch {
            debugPrint(error)
        }
    }

    func readData<T: Object>(_ object: T.Type) throws -> Results<T> {
        guard let realm else { throw RealmError.invalidInitialize }
        return realm
            .objects(object)
            .sorted(byKeyPath: "title", ascending: true)
    }

    func updateData<T: Object>(data: T, completion: ((T) -> Void)) {
        guard let realm else { return }
        do {
            try realm.write {
                completion(data)
                realm.add(data, update: .modified)
                print("Realm update completed")
            }
        } catch {
            debugPrint(error)
        }
    }

    func deleteData<T: Object>(data: T) {
        guard let realm else { return }
        do {
            try realm.write {
                realm.delete(data)
                print("Realm delete completed")
            }
        } catch {
            debugPrint(error)
        }
    }

}
