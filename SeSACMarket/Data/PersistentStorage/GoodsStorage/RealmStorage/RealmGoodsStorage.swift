//
//  RealmGoodsStorage.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/10.
//

import Foundation
import RealmSwift

final class RealmGoodsStorage {

    private let realmStorage: RealmStorage

    init(realmStorage: RealmStorage) {
        self.realmStorage = realmStorage
    }

}

extension RealmGoodsStorage: GoodsStorage {
    func createGoodsData(goodsEntity: GoodsEntity) {
        realmStorage.createData(data: goodsEntity)
    }

    func readGoodsData() -> [GoodsEntity] {
        do {
            return try realmStorage.readData(GoodsEntity.self).map { $0 }
        } catch {
            print("🙅‍♂️", error)
            return []
        }
    }

    func deleteGoodsData(goodsEntity: GoodsEntity) {
        do {
            let realm = try Realm()
            if let object = realm.object(
                ofType: GoodsEntity.self,
                forPrimaryKey: goodsEntity.productID
            ) {
                realmStorage.deleteData(data: object)
            }
        } catch {
            print("🙅‍♂️", error)
        }
    }

}
