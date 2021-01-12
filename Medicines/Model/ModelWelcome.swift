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
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Properties
    var presentTitle = ""
    var presentDescription = ""
    var currentPage = 0 // Текущая страница
    var numberOfPage = 0 // Общее количество страниц
    
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
        nextButton.setTitle("Дальше", for: .normal)
        nextButton.layer.cornerRadius = 25
        
    }
    
}
