//
//  NewMedicinesTableViewController.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 17.11.2020.
//

import UIKit

class NewMedicinesTableViewController: UITableViewController {
    
    var newMedicine: Medicines?
    var imageIsChanged = false
    var datePicker: UIDatePicker!

    @IBOutlet weak var medicinesImageIV: UIImageView!
    @IBOutlet weak var medicinesNameTF: UITextField!
    @IBOutlet weak var medicinesTypeTF: UITextField!
    @IBOutlet weak var medicinesExpiryDataTF: UITextField!
    
    @IBOutlet weak var saveButtonBBI: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView() // Отключаем разлиновку TableView ниже имеющихся ячеек
        
        // Пока что я не знаю как задать цвет не использованным ячейкам, возможно их надо записать в протокол Delegate. Но я еще не разобрался как это сделать. На данный момент цвет ячейкам задал из интерфейса xcode
        self.tableView.backgroundColor = colorBackground // Задаём цвет TableView из стилей
        
        // Делаем кнопку сохранения не активной для того, чтобы позже сдеkать её активной после заполнения medicinesNameTF
        saveButtonBBI.isEnabled = false

        // Создаём отслеживание заполение TF medicinesNameTF, для активации кнопки сохранения
        medicinesNameTF.addTarget(self, action: #selector(changedMedicinesNameTF), for: .editingChanged)
        
        
        // Включаем в обработку метод для выбора даты
        setupDataPicker()
        
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
    
    // Метод для созранения новых объектов
    func saveNewMedicine() {
        var image: UIImage?
        
        // если изображение было выбрано пользователем, то присваимаем пользовательское изображение.
        if imageIsChanged {
            image = medicinesImageIV.image
        } else {
            image = UIImage(named: "noImage")
        }
        
        newMedicine = Medicines(name: medicinesNameTF.text!, type: medicinesTypeTF.text, expiryDate: medicinesExpiryDataTF.text, image: image, imageTest: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        // Добавляем возможность выхода из окна (необходимо для поддержки iOS младше 13.0)
        dismiss(animated: true)
    }
}

// MARK: - TextField Delegate
extension NewMedicinesTableViewController: UITextFieldDelegate {
    
    // Скрываем клавиатуру по нажатию Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Отслеживаем изменения для активации кнопки сохранения
    @objc private func changedMedicinesNameTF() {
        if medicinesNameTF.text?.isEmpty == false { // Проверяем пустое ли поле
            saveButtonBBI.isEnabled = true // Если поле не пустое, активируем кнопку
        } else {
            saveButtonBBI.isEnabled = false // Если пустое, кнопка не активна
        }
    }
    
    // Метод для создания ввода даты через барабан в поле срока годности
    func setupDataPicker() {
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 280))
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)
        
        if #available(iOS 13.4, *) {
            // Выбираем стиль в виде барабана
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        
        // Задаём ширину тулбара для кнопок
        let toolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        
        // Не совсем понимаю зачем эта штука нужна, без неё всё работает
        let spaceBurron: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        
        // Настраиваем кнопку готово
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.tapOnDoneButton))
        
        // Размещаем кнопки на тулбаре
        toolBar.setItems([spaceBurron, doneButton], animated: true)
        
        // Присваиваем полю срока годности способ воода через созданный барабан
        self.medicinesExpiryDataTF.inputView = datePicker
        self.medicinesExpiryDataTF.inputAccessoryView = toolBar
    }
    
    // Задаём стиль форматирования
    @objc private func dateChanged() {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .short
        
        self.medicinesExpiryDataTF.text = dateFormat.string(from: datePicker.date)
    }
    
    // Скрываем барабан ввода даты по кнопке готово
    @objc private func tapOnDoneButton() {
        medicinesExpiryDataTF.resignFirstResponder()
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
        medicinesImageIV.image = info[.editedImage] as? UIImage
        // Масштабируем изображение по содержимому
        medicinesImageIV.contentMode = .scaleAspectFill
        // Обрезаем по границе изображения
        medicinesImageIV.clipsToBounds = true
        // Меняем свойство выбранного изображения, чтобы не менять выбранную картинку на картинку по умолчанию
        imageIsChanged = true
        // Закрываем контроллер
        dismiss(animated: true)
    }
}
