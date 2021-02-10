//
//  StyleManager.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 12.11.2020.
//
//  Полностью адокументированный файл

// TODO: Переделать дизайн под карточки и использовать их белым цветом.
// Подобрать палитры можно тут https://get-color.ru
// Названия цветов искать тут https://colorscheme.ru/color-names.html
// Пример кода взят отсюда https://habr.com/ru/company/bcs_company/blog/493096/

import UIKit

/// Класс содержит собственные цвета для приложения.
class CustomColors {
    
    /// Свойство создаёт экземпляр класса и содержит в себе набор цветовых схем
    /// - background - используется для фона.
    /// - selected - используется  для выделений.
    /// - delete - используется для объектов помеченных на удаление.
    /// - icon - используется для иконок
    /// - navigationBar - Используется  для шапок.
    static let color = CustomColors()
    
    // color literal (Пока я новичек, чтобы не забыть как вызвать выбор цвета)
    // TODO: Вместо использования цветов на прямую в будущем сделать через функцию, для назначения цвета в зависимости от темы проиложения (дневная/ночная)
    
    // MARK: - Light Stile
    /// Используется для фона. Умеренный аквамариновый
    let background = #colorLiteral(red: 0.4078431373, green: 0.8156862745, blue: 0.6823529412, alpha: 1)
    
    /// Используется для выделений. Вердепешевый
    let selected = #colorLiteral(red: 0.8156862745, green: 0.7882352941, blue: 0.4078431373, alpha: 1)
    
    /// Используется для объектов помеченных на удаление. Розовый антик
    let delete = #colorLiteral(red: 0.8156862745, green: 0.4823529412, blue: 0.4078431373, alpha: 1)
    
    /// Используется для иконок. Аметистовый
    let icon = #colorLiteral(red: 0.5176470588, green: 0.4078431373, blue: 0.8156862745, alpha: 1)
    
    // MARK: Цвета не подобранные палитрой
    /// Используется  для шапок. Лиственный зеленый Крайола.
    let navigationBar = #colorLiteral(red: 0.4352941176, green: 0.6941176471, blue: 0.6039215686, alpha: 1)

    /// Используется для объектов помеченных на удаление. Красно-оранжевый Крайола.
//    let iconAppColor = #colorLiteral(red: 1, green: 0.3137254902, blue: 0.2862745098, alpha: 1)
    

    
}

extension UIColor {
    
    // MARK: - Light Style properties
    /// Используется для фона. Умеренный аквамариновый
    static let background = #colorLiteral(red: 0.4078431373, green: 0.8156862745, blue: 0.6823529412, alpha: 1)
    
    /// Используется для выделений. Вердепешевый
    static let selected = #colorLiteral(red: 0.8156862745, green: 0.7882352941, blue: 0.4078431373, alpha: 1)
    
    /// Используется для объектов помеченных на удаление. Розовый антик
    static let delete = #colorLiteral(red: 0.8156862745, green: 0.4823529412, blue: 0.4078431373, alpha: 1)
    
    /// Используется для иконок. Аметистовый
    static let icon = #colorLiteral(red: 0.5176470588, green: 0.4078431373, blue: 0.8156862745, alpha: 1)
    
    // MARK: Цвета не подобранные палитрой
    /// Используется  для шапок. Лиственный зеленый Крайола.
    static let navigationBar = #colorLiteral(red: 0.4352941176, green: 0.6941176471, blue: 0.6039215686, alpha: 1)

    /// Используется для объектов помеченных на удаление. Красно-оранжевый Крайола.
//    let iconAppColor = #colorLiteral(red: 1, green: 0.3137254902, blue: 0.2862745098, alpha: 1)
    
    // MARK: - Functions
    /// Метод назначает автоматическое переключение тёмной и светлой темы оформления, в зависимости от системных настроек. Для iOS ниже 13 версии, оформление всегда берется из светлого значения.
    static func customColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? dark : light
            }
        } else {
            return light
        }
    }
    
}
