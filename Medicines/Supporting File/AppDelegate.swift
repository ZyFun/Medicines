//
//  AppDelegate.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 12.11.2020.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Для запуска на iOS >13.0
    var window: UIWindow?
    
    // Создаём экземпляр класса для обращения к методам.
    let notifications = Notifications()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Вызываем метод для запроса на отправку уведомлений
        notifications.requestAutorization()
        
        // Назначаем делегата, чтобы уведомление отображалось при активном приложении
        notifications.notificationCenter.delegate = notifications
        
//        // Метод отслеживающий возвращение в приложение (сообщает делегату, что приложение вновь активно)
//        func applicationDidBecomeActive(application: UIApplication) {
//            // Обнуляем счетчик на бейдже, если приложение стало активным или было активным
//            UIApplication.shared.applicationIconBadgeNumber = 0
//        }
        
        // Конфигурация для обновления версии схемы базы данных (для переноса старых данных в новую базу)
        let config = Realm.Configuration(
            // Версия схемы данных. Если схема данных меняется, необходимо увеличить значение на +1
            schemaVersion: 8,

            // Устанавливаем блок, который будет вызываться автоматически при открытии Realm если предыдущая версия была ниже вновь установленной
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 8) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })

        // Назначаем вновь настроенную конфигурацию, как конфигурацию по умолчанию
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

