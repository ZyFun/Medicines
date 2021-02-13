//
//  MedicinesTableViewCell.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 13.11.2020.
//

import UIKit

class MedicinesTableViewCell: UITableViewCell {
    @IBOutlet weak var imageMedicines: UIImageView! {
        didSet{
            imageMedicines.layer.cornerRadius = 20 //frame.size.height / 2 // Скругляем края
            clipsToBounds = true // Обрезаем для скругления
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var expiryDataLabel: UILabel!
    @IBOutlet weak var trashLabel: UILabel! {
        didSet {
            trashLabel.text = "В мусор"
            trashLabel.backgroundColor = .customColor(light: UIColor.light.delete, dark: UIColor.dark.delete)
            trashLabel.layer.masksToBounds = true
            trashLabel.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var amountLabel: UILabel!
    
}
