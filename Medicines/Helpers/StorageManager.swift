//
//  StorageManager.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 23.11.2020.
//

import RealmSwift

/// Свойство создаётся для предоставления глобального доступа к базе данных из файла StorageManager
let realm = try! Realm()

/// Класс для работы с базой данных
class StorageManager {
    /// Метод для сохранения данных в базе
    static func saveObject(_ medicine: Medicine) {
        // Добавляем данные в базу данных
        try! realm.write {
            realm.add(medicine)
        }
    }
    
    /// Метод для удаления данных из базы
    static func deleteObject (_ medicine: Medicine){
        // Удаляем данные из базы данных
        try! realm.write {
            realm.delete(medicine)
        }
    }
}
