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

extension UIColor {
    
    // MARK: - Light Style properties
    
    /**
     Свойство с набором цветовых палитр для светлой темы.
     
     - background - используется для фона.
     - selected - используется  для выделений.
     - delete - используется для объектов помеченных на удаление.
     - icon - используется для иконок
     - navigationBar - Используется  для шапок.
     */
    enum light {
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
    }
    
    // MARK: - Dark Style properties
    
    /**
     Свойство с набором цветовых палитр для темной темы.
     
     - background - используется для фона.
     - selected - используется  для выделений.
     - delete - используется для объектов помеченных на удаление.
     - icon - используется для иконок
     - navigationBar - Используется  для шапок.
     */
    enum dark {
        /// Используется для фона. Ядовито-зеленый.
        static let background = #colorLiteral(red: 0.2274509804, green: 0.4549019608, blue: 0.3843137255, alpha: 1)
        
        /// Используется для выделений. Бледно-коричневый.
        static let selected = #colorLiteral(red: 0.4509803922, green: 0.4, blue: 0.2823529412, alpha: 1)
        
        // MARK: Цвета не подобранные палитрой
        /// Используется для иконок. Умеренный аспидно-синий.
        static let icon = #colorLiteral(red: 0.5176470588, green: 0.5153243402, blue: 0.8156862745, alpha: 1)
        
        /// Используется для объектов помеченных на удаление. Сочный каштановый Крайола.
        static let delete = #colorLiteral(red: 0.6941176471, green: 0.3098039216, blue: 0.2823529412, alpha: 1)
        
        /// Используется  для шапок. Сосновый зеленый
        static let navigationBar = #colorLiteral(red: 0.1607843137, green: 0.3176470588, blue: 0.2666666667, alpha: 1)
    }
    
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
