//
//  WelcomeViewController.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 12.12.2020.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet var holderView: UIView!
    
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        // Массив для перебора заголовков у окна
        let titles = ["Привет!", "Лекарства", "Roadmap"]
        // массив для содежимого описания
        let subs = ["ВО первых", "во вторых", "Планы"]
        // Делаем цикл переборки наших экранов с информацией
        for x in 0..<3 {
            // Задаём координаты отображения окна информации
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * holderView.frame.size.width, y: 0, width: holderView.frame.size.width, height: holderView.frame.size.height))
            // Добавляем сконфигурированное окно в прокрутку
            scrollView.addSubview(pageView)
            
            // Настраиваем, что показывать в окне
            // TODO: Впихнуть сюда свой текст, а пока возьму из примера. Я буду конфигурировать всё это не в коде. А может так и оставлю.
            // Конфигурируем расположение лейбла
            let label = UILabel(frame: CGRect(x: 10, y: 10, width: pageView.frame.size.width - 20, height: 120))
            let textView = UITextView(frame: CGRect(x: 10, y: 10 + 120 + 10, width: pageView.frame.size.width - 20, height: pageView.frame.size.height - 60 - 130 - 15))
            let buttonNext = UIButton(frame: CGRect(x: 10, y: pageView.frame.size.height - 60, width: pageView.frame.size.width - 20, height: 50))
            
            // Конфигурируем параметры свойств
            label.textAlignment = .center
            // Задаём стиль текста
            label.font = UIFont(name: "Helvetica-Bool", size: 50)
            // Добавляем лейбл на окно
            pageView.addSubview(label)
            // Вносим заголовки из массива
            label.text = titles[x]
            
            // Конфигурируем описание
            textView.textAlignment = .center
            textView.text = subs[x]
            pageView.addSubview(textView)

            // Конфигурируем кнопку
            buttonNext.setTitleColor(.white, for: .normal)
            buttonNext.backgroundColor = .black
            buttonNext.setTitle("Дальше", for: .normal)
            // настраиваем заголовок для последней кнопки
            if x == 2 {
                buttonNext.setTitle("Поехали!", for: .normal)
            }
            // Кнопка сама выполняет действия по нажатию
            buttonNext.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            buttonNext.tag = x + 1
            pageView.addSubview(buttonNext)
        }
        
        scrollView.contentSize = CGSize(width: holderView.frame.size.width, height: 0 )
        scrollView.isPagingEnabled = true
    }
    
    // Функция действия кнопки
    @objc func didTapButton(_ button: UIButton) {
        guard button.tag < 3 else {
            // Устанавливаем метку, что пользователь больше не является новым
            Core.shared.setIsNotNewUser()
            dismiss(animated: true, completion: nil)
            return
        }
        scrollView.setContentOffset(CGPoint(x: holderView.frame.size.width * CGFloat(button.tag), y: 0), animated: true)
    }
}
