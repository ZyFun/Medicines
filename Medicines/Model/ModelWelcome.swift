//
//  ModelWelcome.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 11.01.2021.
//

import UIKit

class ModelWelcome: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var pageControl: UIPageControl!
    @IBOutlet weak private var nextButton: UIButton!
    
    // MARK: - Properties
    var presentTitle = ""
    var presentDescription = ""
    var currentPage = 0 // Текущая страница
    var numberOfPage = 0 // Общее количество страниц
    let welcomePageVC = WelcomePageViewController()
    
    // MARK: - Load app
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Setup view config
        view.backgroundColor = colorBackground
        
        // MARK: Setup presentation config
        titleLabel.text = presentTitle
        descriptionLabel.text = presentDescription
        pageControl.numberOfPages = numberOfPage
        pageControl.currentPage = currentPage
        
        // MARK: Setup buttons config
        nextButton.setTitleColor(.black, for: .normal)
        nextButton.backgroundColor = colorSelected
        nextButton.setTitle("Поехали!", for: .normal)
        nextButton.layer.cornerRadius = 25
        // TODO: Сделать возможность нажимать на кнопку и листать контроллер, а так же под конец презентации выходить из неё
        nextButton.isHidden = true
        if currentPage == welcomePageVC.titleWelcome.count - 1 {
            nextButton.isHidden = false
        }
        
    }
    
    // MARK: - Actions
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        // Закрываем презентацию и записываем ключь не нового пользователя
        FirstStartApp.shared.setIsNotNewUser()
        dismiss(animated: true, completion: nil)
            
        return
    }
    
}
