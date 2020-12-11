//
//  StorageManager.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 23.11.2020.
//

import RealmSwift

// Создаём объект для предоставления доступа к базе данных
let realm = try! Realm()

// Создаём класс для работы с этой базой данных
class StorageManager {
    // Создаём метод для сохранения данных
    static func saveObject(_ medicine: Medicine) {
        // Добавляем данные в базу данных
        try! realm.write {
            realm.add(medicine)
        }
    }
    
    // Создаём метод для удаления из базы данных
    static func deleteObject (_ medicine: Medicine){
        // Удаляем данные из базы данных
        try! realm.write {
            realm.delete(medicine)
        }
    }
}
