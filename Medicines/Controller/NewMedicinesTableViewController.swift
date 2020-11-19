//
//  NewMedicinesTableViewController.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 17.11.2020.
//

import UIKit

class NewMedicinesTableViewController: UITableViewController {

    @IBOutlet weak var imageMedicines: UIImageView!
    
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
            // Создаём алерт контроллер (выползающее меню снизу) для добавления фото
            let choosePhoto = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            // Создаём алерт контроллер для iPad
            if let popoverController = choosePhoto.popoverPresentationController {
                popoverController.sourceView = self.view //to set the source of your alert
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
                popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
                       }
            
            // Создаём экземпляр экшна для выбора изображения с камеры
            let camera = UIAlertAction(title: "Камера", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            
            // Создаём экземпляр экшна для выбора изображения из библиотеки
            let photo = UIAlertAction(title: "Фотографии", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            
            // Создаём экземпляр экшна для выхода из контролера
            let cancel = UIAlertAction(title: "Отмена", style: .cancel)
            
            // Добавляем в контроллер созданные экшены
            choosePhoto.addAction(camera)
            choosePhoto.addAction(photo)
            choosePhoto.addAction(cancel)
            
            // Вызываем созданный контроллер
            present(choosePhoto, animated: true)
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

// MARK: - Работа с изображениями
extension NewMedicinesTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        // Проверяем доступность источника выбора изображений
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            // Назначаем imagePicker делегатом функции imagePickerController. Протокол: UINavigationControllerDelegate
            imagePicker.delegate = self
            // Включаем возможность редактировать выбранное изображение
            imagePicker.allowsEditing = true
            // Определяем тип источника выбранного изображения
            imagePicker.sourceType = source
            // Вызываем контроллер
            present(imagePicker, animated: true)
        }
    }
    
    // Добавляем метод, позваляющий добавить выбранное изображение протокол: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Присваиваем свойство отредактированного изображения
        imageMedicines.image = info[.editedImage] as? UIImage
        // Масштабируем изображение по содержимому
        imageMedicines.contentMode = .scaleAspectFill
        // Обрезаем по границе изображения
        imageMedicines.clipsToBounds = true
        // Закрываем контроллер
        dismiss(animated: true)
    }
}
