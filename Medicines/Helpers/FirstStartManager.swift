//
//  FirstStartManager.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 23.11.2020.
//

import RealmSwift

/// Класс с логикой первого запуска приложения. Используется для показа всплывающего окна приветствия и создания первого объекта в базе данных
class FirstStartApp {
    
    // MARK: - Properties
    /// Свойство создаёт экземпляр класса FirstStartApp
    static let shared = FirstStartApp()
    
    // MARK: - Functions
    /// Создаёт тестовый объект если массив пустой. Используется для обучения пользователя при первом запуске приложения.
    /// - Инициализируем переменную с объектами базы данных и делаем запрос этих объектов из базы данных. Для того, чтобы понять пустая база или нет. И на основе этого создать тестовый учебный объект. Это необходимо сделать, потому что при публикации новой версии приложения могу допустить ошибку, и этот объект создастся уже в заполненной таблице.
    func learningNewObjectGet() {
        
        var learningMedicines: Results<Medicine>! // Инициализируем переменную с объектами базы данных
        
        learningMedicines = realm.objects(Medicine.self) // Делаем запрос объектов из базы данных
        
        // Создаём новый объект, если массив базы пустой.
        if learningMedicines.isEmpty {
            let image = UIImage(named: "noImage")
            let imageData = image?.pngData()
            let lerning = Medicine(name: "Лекарство",
                                   type: "Тестовое",
                                   amount: 1,
                                   expiryDate: Date(), // TODO: Сделать в будущем текущую дату + год вперед.
                                   imageData: imageData)
            
            StorageManager.saveObject(lerning) // Сохраняем учебный объект в базу данных.
            
        }
    }
    
    /// Метод проверяет наличие ключа  "isNewUser" в UserDefaults. Используется для логики запуска окна приветствия если ключа нет.
    func isNewUser() -> Bool{
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    /// Метод устанавливает ключь "isNewUser" в UserDefaults. Используется для того, чтобы окно приветствия больше не показывалось.
    func setIsNotNewUser(){
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
    
    /// Метод проверяет наличие ключа "firstAddObject" в UserDefaults. Используется для логики добавления в базу пробной записи с лекарством, который пользователь в дальнейшем удалит. Если ключа нет.
    func isFirstOpenAidKit() -> Bool{
        return !UserDefaults.standard.bool(forKey: "firstAddObject")
    }
    
    /// Метод устанавливает ключь "firstAddObject" в UserDefaults. Используется для того, чтобы пробная запись больше не создавалась.
    func setIsNotFirstOpenAidKit(){
        UserDefaults.standard.set(true, forKey: "firstAddObject")
    }
}

