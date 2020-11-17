//
//  NewMedicinesTableViewController.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 17.11.2020.
//

import UIKit

class NewMedicinesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView() // Отключаем разлиновку TableView ниже имеющихся ячеек
        
        // Пока что я не знаю как задать цвет не использованным ячейкам, возможно их надо записать в протокол Delegate. Но я еще не разобрался как это сделать. На данный момент цвет ячейкам задал из интерфейса xcode
        self.tableView.backgroundColor = colorBackground // Задаём цвет TableView из стилей
        
    }

    // MARK: - TableView Delegate
    // Скрываем клавиатуру при тапе на ячейку, кроме первой с фотографией
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else {
            view.endEditing(true)
        }
    }
}

// MARK: - TextField Delegate
extension NewMedicinesTableViewController: UITextFieldDelegate {
    
    // Скрываем клавиатуру по нажатию Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
