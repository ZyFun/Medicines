//
//  Notifications.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 24.12.2020.
//

import UIKit
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    // Создаём экземпляр класса, для управлением уведомлениями. current возвращет обект для центра уведомлений
    let notificationCenter = UNUserNotificationCenter.current()
    
    // Метод получения запроса у пользователя для разрешения на отправку уведомлений
    func requestAutorization() {
        
        // Метод запроса авторизации. options это те уведомления которые мы хотим отправлять. Булево значение обозночает, прошла авторизация или нет
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Разрешение получено: \(granted)")
            
            guard granted else { return }
            self.getNotificationsSettings()
        }
        
    }
    
    // Метод для отслеживания настроек (включены или отключены уведомления)
    func getNotificationsSettings() {
        
        // Проверяем состояние авторизаций или параметров уведомлений
        // TODO: Посмотреть как можно запросить к примеру включить уведомления обратно, если пользователь их отключил
        notificationCenter.getNotificationSettings { (settings) in
            print("Настройки получены: \(settings)")
        }
        
    }
    
    // TODO: Реализовать получение даты из базы данных
    
    
    // Создаём метод для получения даты из базы данных и получения уведомления
    func notification(reminder: Date?) {
        
        // Безопасно извлекаем дату, и если не получилосб, выходим из функйии
        guard let date = reminder else {
            print("oops")
            return
        }
        // Создаём экземпляр класса календаря, для разбивки на компоненты полученной даты
        let calendar = Calendar.current // TODO: Что делает current?
        // Разбиваем полученную дату на компоненты для триггера уведомления
        let component = calendar.dateComponents([.year, .month, .day], from: date)
        // Создаём триггер срабатывания уведомления по календарю
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: true)
        
        // Создаём экземпляр класса. Для настройки контента уведомлений
        let content = UNMutableNotificationContent()
        // Настраиваем контент для показа
        content.title = "Просрочено"
        content.body = "Пора выбросить лекарство: " + "" // TODO: Сделать загрузку названия лекарства вместо пустой строки
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        // Создаём идентификатор для запроса уведомления
        let identifier = "\(date)" // TODO: Таким образом для каждого уведомления будет свой идентификатор, и для каждого лекарства будет своё уведомление о просрочке. Убедится что это именно так. Иначе старые уведомления будут удаляться
        
        // Создаём запроса уведомления
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // Вызываем запрос уведомления через центр уведомлений и обрабатываем ошибку, если что то пойдет не так
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                //TODO: Принт из примера обработки ошибок, хочу посмотреть что он покажет если что то пойдет не так
                print(error as Any)
            }
        }
        
    }
    
    // Метод для показа уведомлений во время активного приложения
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Отображаем уведомление со звуком
        completionHandler([.alert, .sound])
        
    }
    
//    // TODO: Добавить метод, чтобы при нажатии на уведомление что то происзодило.
//    // Метод для того, чтобы по нажатию на уведомление, что то происходило (пример с одного из уроков)
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        // Создаём действие которое происходит по нажатию на уведомление
//        if response.notification.request.identifier == "Local Notification" {
//            print("На уведомление нажали")
//        }
//        // Зачем то что то вызываем, он не объяснил зачем. Надо разобраться
//        completionHandler()
//    }
    
//        // Метод для отображения уведомлений
//        // TODO: Реализовать новый массив с данными из просроченных лекарств, с него считать количество просрочек и отображать на иконке приложения
//        func setupBage() {
//            UIApplication.shared.applicationIconBadgeNumber = 1
//        }
    
}
