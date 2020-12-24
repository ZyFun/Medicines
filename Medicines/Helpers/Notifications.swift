//
//  Notifications.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 24.12.2020.
//

import UIKit
import UserNotifications

class Notifications: NSObject {
    
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
    
}
