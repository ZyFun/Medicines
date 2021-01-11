//
//  WelcomeContent.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 11.01.2021.
//

import UIKit

class WelcomeContent: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Load App
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - Style Config
        view.backgroundColor = colorBackground
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
