//
//  WelcomePageViewController.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 11.01.2021.
//

import UIKit

class WelcomePageViewController: UIPageViewController {
    
    // MARK: - Properties
    let titleWelcome = ["Привет!", "Лекарства", "Планы", "Планы"]
    private let descriptionWelcome = [
        "Спасибо за установку моего приложения! Надеюсь что оно поможет тебе поддерживать свою аптечку и хранящиеся в ней лекарства в актуальном состоянии.",
        "Это приложение поможет тебе при покупке новых лекарств. К примеру, выписали новые лекарства, и уже по дороге домой можно посмотреть, а есть ли подобные в аптечке или стоит купить новые",
        "В будущем планируется много дополнений, одни из них: сохранение истории принятых лекарств и журнал напоминалка, о приёме лекарств. Именно по этому на данный момент доступен только 1 пункт с аптечкой. Да и в целом, вся структура главного окна будет перерабатываться. \n\nЕсли у тебя есть идеи по доработке, обязательно пиши об этом в отзывах. Учту всё и постараюсь сделать по твоим пожеланиям.",
        "На данный момент это самая первая версия приложения и оно будет развиваться. Добавятся новые функции и со временем сделаю более красивый дизайн. Сейчас работа больше идет над функционалом и в данный момент доступен основной, хранение списка лекарств и напоминание о том, что оно просрочено. Я только учусь и твой отзыв очень поможет мне в этом не лёгком деле 🤓",
    ]

    // MARK: - Load app
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Назначаем класс делегатом протокола для возможности перелистывания страниц
        dataSource = self
        
        // Загружаем модель контроллера с контентом и если это получается, то создаём массив контроллеров
        if let welcomeModel = showViewControllerAtIndex(0) {
            setViewControllers([welcomeModel], direction: .forward, animated: true, completion: nil)
        }

    }
    
    // MARK: - Functions
    // Функция, принимает параметры из массива  по индексу страницы и возвращает значение по индексу из массива в окне приветствия
    private func showViewControllerAtIndex(_ index: Int) -> WelcomeViewController? {
        
        // Безопасно извлекаем данные и возвращаем nil, если что то пойдет не так
        guard index >= 0 else { return nil }
        guard index < titleWelcome.count else { return nil }
        // Поддержка iOS младше 12. 13 и старше вместо withIdentifier используется identifier
        guard let welcomeViewController = storyboard?.instantiateViewController(withIdentifier: "WelcomeContentViewController") as? WelcomeViewController else { return nil }
        
        // MARK: Setup properties
        welcomeViewController.presentTitle = titleWelcome[index]
        welcomeViewController.presentDescription = descriptionWelcome[index]
        welcomeViewController.currentPage = index
        welcomeViewController.numberOfPage = titleWelcome.count
        
        return welcomeViewController
    }
    
}

// MARK: - Extension
// Расширение для управления перелистывания страниц
extension WelcomePageViewController: UIPageViewControllerDataSource {
    
    // Перелистывание на предыдущую страницу
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var pageNumber = (viewController as! WelcomeViewController).currentPage
        pageNumber -= 1
        
        return showViewControllerAtIndex(pageNumber)
        
    }
    
    // Перелистывание на следующую страницу
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var pageNumber = (viewController as! WelcomeViewController).currentPage
        pageNumber += 1
        
        return showViewControllerAtIndex(pageNumber)
        
    }
}
