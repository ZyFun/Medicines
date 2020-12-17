//
//  WelcomeViewController.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 12.12.2020.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var holderView: UIView!
    
    private let scrollView = UIScrollView()
    // Массив для перебора заголовков у окна
    private let titles = ["Привет!", "Лекарства", "Планы", "Планы"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = colorBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configure()
    }
    
    // Функция настройки прокрутки в окне приветствия
    private func configure() {
        // Конфигурируем фрейм прокрутки
        scrollView.frame = holderView.bounds
        // Добавляем прокрутку
        holderView.addSubview(scrollView)
        holderView.backgroundColor = colorBackground
        
        // Массив c описанием программы
        let subs = [
            "Спасибо за установку моего приложения! Надеюсь что оно поможет тебе поддерживать свою аптечку и хранящиеся в ней лекарства в актуальном состоянии.",
            "Это приложение поможет тебе при покупке новых лекарств. К примеру, выписали новые лекарства, и уже по дороге домой можно посмотреть, а есть ли подобные в аптечке или стоит купить новые",
            "В будущем планируется много дополнений, одни из них: сохранение истории принятых лекарств и журнал напоминалка, о приёме лекарств. Именно по этому на данный момент доступен только 1 пункт с аптечкой. Да и в целом, вся структура главного окна будет перерабатываться. \n\nЕсли у тебя есть идеи по доработке, обязательно пиши об этом в отзывах. Учту всё и постараюсь сделать по твоим пожеланиям.",
            "На данный момент это самая первая версия приложения и оно будет развиваться. Добавятся новые функции и со временем сделаю более красивый дизайн. Сейчас работа больше идет над функционалом и в данный момент доступен основной, хранение списка лекарств и напоминание о том, что оно просрочено. Я только учусь и твой отзыв очень поможет мне в этом не лёгком деле 🤓"
        ]
        
        // Делаем цикл переборки наших экранов с информацией
        for x in 0..<titles.count {
            // Задаём координаты отображения окна информации
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * holderView.frame.size.width, y: 0, width: holderView.frame.size.width, height: holderView.frame.size.height))
            // Добавляем сконфигурированное окно в прокрутку
            scrollView.addSubview(pageView)
            
            // Настраиваем, что показывать в окне
            // Конфигурируем расположение лейбла
            let titleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: pageView.frame.size.width - 20, height: 120))
            let descriptionLabel = UILabel(frame: CGRect(x: 10, y: 0, width: pageView.frame.size.width - 20, height: pageView.frame.size.height - 60 - 130 - 15))
            let buttonNext = UIButton(frame: CGRect(x: 100, y: pageView.frame.size.height - 100, width: pageView.frame.size.width - 200, height: 50))
            
            // Конфигурируем параметры свойств
            titleLabel.textAlignment = .center
            // Задаём стиль текста
            titleLabel.font = UIFont(name: "HelveticaNeue", size: 35)
            // Вносим заголовки из массива
            titleLabel.text = titles[x]
            // Добавляем лейбл на окно
            pageView.addSubview(titleLabel)
            
            // Конфигурируем описание
            descriptionLabel.textAlignment = .justified
            descriptionLabel.text = subs[x]
            descriptionLabel.font = UIFont(name: "HelveticaNeue", size: 18)
            descriptionLabel.numberOfLines = 0
            pageView.addSubview(descriptionLabel)

            // Конфигурируем кнопку
            buttonNext.setTitleColor(.black, for: .normal)
            buttonNext.backgroundColor = colorSelected
            buttonNext.layer.cornerRadius = 25
            buttonNext.setTitle("Дальше", for: .normal)
            // настраиваем заголовок для последней кнопки
            if x == titles.count - 1 {
                buttonNext.setTitle("Поехали!", for: .normal)
            }
            // Кнопка сама выполняет действия по нажатию
            buttonNext.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            buttonNext.tag = x + 1
            pageView.addSubview(buttonNext)
        }
        
        scrollView.contentSize = CGSize(width: holderView.frame.size.width, height: 0)
        scrollView.isPagingEnabled = true
    }
    
    // Функция действия кнопки
    @objc func didTapButton(_ button: UIButton) {
        guard button.tag < titles.count else {
            // Устанавливаем метку, что пользователь больше не является новым
            FirstStartApp.shared.setIsNotNewUser()
            dismiss(animated: true, completion: nil)
            return
        }
        scrollView.setContentOffset(CGPoint(x: holderView.frame.size.width * CGFloat(button.tag), y: 0), animated: true)
    }
}
