//
//  ModelMedicines.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 16.11.2020.
//

import Foundation

struct Medicines {
    var name: String
    var type: String
    var expiryDate: String
    var image: String
    
    // Массив с именами лекарств
    static let medicinesName = ["Анальгин","Терафлю","Маалокс"]
    
    // Загружаем в таблицк модель данных (Временное решение для теста)
    static func getMedicines() -> [Medicines] {
        var medicines = [Medicines]()
        
        for medicine in medicinesName {
            medicines.append(Medicines.init(name: medicine, type: "Антибиотик", expiryDate: "21.12.2020", image: medicine))
        }
        return medicines
    }
}