//
//  FirstStartManager.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 23.11.2020.
//

import RealmSwift

// Временное решение для теста. Создаёт тестовый объект если массив пустой для обучения пользователя
// TODO: Реализовать подобное, но для единичного запуска при первой установке приложения
func learningNewObjectGet() {
    var learningMedicines: Results<Medicine>!
    // Инициализируем переменную с объектами базы данных и делаем запрос этих объектов из базы данных. Для того, чтобы понять пустая база или нет. И на основе этого создать тестовый учебный объект
    learningMedicines = realm.objects(Medicine.self)
    if learningMedicines.isEmpty {
        let image = UIImage(named: "noImage")
        let imageData = image?.pngData()
        let lerning = Medicine(name: "Лекарство", type: "Тестовое", amount: 1, expiryDate: "21.12.2020", imageData: imageData)
        StorageManager.saveObject(lerning)
    }
}
