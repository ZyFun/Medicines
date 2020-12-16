//
//  ModelMedicines.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 16.11.2020.
//

import UIKit
import RealmSwift

// описываем структуру данных в соответствии с документацией Realm
class Medicine: Object {
    @objc dynamic var name = ""
    @objc dynamic var type: String?
    @objc dynamic var amount = Double() // по умолчанию присваивается 0?
    @objc dynamic var expiryDate: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var date = Date() // Нужно только для сортировки по дате. Пользователь никак не видит это свойство
    
    // Чтобы не приходилось прописывать все эти свойства в ручную, создадим инициализатор. Этот инициализатор не создаёт новый объект, а присваивает уже созданному объекту новые значения
    convenience init(name: String, type: String?, amount: Double, expiryDate: String?, imageData: Data?) {
        // Инициализируем свойства классов значениями по умолчанию
        self.init()
        // Присваиваем значения параметров свойствам класса
        self.name = name
        self.type = type
        self.amount = amount
        self.expiryDate = expiryDate
        self.imageData = imageData
    }
}
