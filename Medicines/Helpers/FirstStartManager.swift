//
//  FirstStartManager.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 23.11.2020.
//

import RealmSwift

// Создаёт тестовый объект если массив пустой для обучения пользователя, при первом запуске приложения.
func learningNewObjectGet() {
    var learningMedicines: Results<Medicine>!
    // Инициализируем переменную с объектами базы данных и делаем запрос этих объектов из базы данных. Для того, чтобы понять пустая база или нет. И на основе этого создать тестовый учебный объект. Это необходимо сделать, потому что при публикации новой версии приложения могу допустить ошибку, и этот объект создастся уже в заполненной таблице.
    learningMedicines = realm.objects(Medicine.self)
    if learningMedicines.isEmpty {
        let image = UIImage(named: "noImage")
        let imageData = image?.pngData()
        let lerning = Medicine(name: "Лекарство",
                               type: "Тестовое",
                               amount: 1,
                               expiryDate: Date(), // TODO: Сделать в будущем текущую дату + год вперед
                               imageData: imageData)
        
        StorageManager.saveObject(lerning)
    }
}

//MARK: - Логика первого запуска
// Логика для всплывающего окна приветствия и создания первого объекта в базе данных
class FirstStartApp {
    static let shared = FirstStartApp()
    
    func isNewUser() -> Bool{
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    func setIsNotNewUser(){
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
    
    func isFirstOpenAidKit() -> Bool{
        return !UserDefaults.standard.bool(forKey: "firstAddObject")
    }
    
    func setIsNotFirstOpenAidKit(){
        UserDefaults.standard.set(true, forKey: "firstAddObject")
    }
}

