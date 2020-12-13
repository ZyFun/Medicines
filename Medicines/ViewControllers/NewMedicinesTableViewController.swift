//
//  NewMedicinesTableViewController.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 17.11.2020.
//
//
// TODO: Возможно стоит доработать код в коммите 5592f31. Было добавлено новое свойство базы данных, (количество лекарств) но из-за небольшого опыта сделал много принудительных извлечений. А так же не знаю как сделать отслеживание нескольких полей одновременно, чтобы не дать сохранить пустое плое. По этому чтобы приложение не падало, добавил только цифровую клавиатуру

import UIKit

class NewMedicinesTableViewController: UITableViewController {
    
    // Вспомогательный объект для передачи выбранных записей из MedicinesTableViewController в этот контроллер
    var currentMedicine: Medicine?
    // Вспомогательный объект для отслеживания выбранного изображения пользователем
    var imageIsChanged = false
    var datePicker: UIDatePicker!

    @IBOutlet weak var medicinesImageIV: UIImageView!
    @IBOutlet weak var medicinesNameTF: UITextField!
    @IBOutlet weak var medicinesTypeTF: UITextField!
    @IBOutlet weak var medicinesAmountTF: UITextField!
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
        
        // Отслеживаем передачу данных с одного контроллерана на другой, и передаём значения если условия совпали
        setupEditScreen()
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
    
    // Метод для сохранения записей
    func saveMedicine() {
        var image: UIImage?
        
        // если изображение было выбрано пользователем, то присваимаем пользовательское изображение.
        if imageIsChanged {
            image = medicinesImageIV.image
        } else {
            image = UIImage(named: "noImage")
        }
        // Создаём вспомагательное свойство image для конвертации в imageData
        let imageData = image?.pngData()
        // Присваиваем все введенные свойства для подготовки к сохранению в базу данных
        let newMedicine = Medicine(name: medicinesNameTF.text!,
                                   type: medicinesTypeTF.text,
                                   amount: Int(medicinesAmountTF.text!) ?? 0, // TODO: сделать проверку на заполнение текстового поля и не сохранять если оно пустое
                                   expiryDate: medicinesExpiryDataTF.text,
                                   imageData: imageData)
        
        // Определяем в каком методе мы находимся, в режиме редактирования или в режиме добавления новой записи
        // Проверяем свойство на отсутствие значения
        if currentMedicine != nil {
            // И если оно не пустое, меняем значение объекта на новое
            // Считываем данные из базы данных и перезаписываем их
            try! realm.write {
                currentMedicine?.name = newMedicine.name
                currentMedicine?.type = newMedicine.type
                currentMedicine?.amount = newMedicine.amount
                currentMedicine?.expiryDate = newMedicine.expiryDate
                currentMedicine?.imageData = newMedicine.imageData
            }
        } else {
            //Сохраняем все введенные значения в базу данных если объект новый
            StorageManager.saveObject(newMedicine)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        // Добавляем возможность выхода из окна (необходимо для поддержки iOS младше 13.0)
        dismiss(animated: true)
    }
    
    // Метод для экрана редактирования записи
    private func setupEditScreen() {
        // Если свойство currentMedicine не имеет значения, то есть в него не было передано данных из MainViewController, то данные не заполняются, иначе данные передаются в поля для редактирования
        if currentMedicine != nil {
            // Вызываем метод редактирования NavigationBar
            setupNavigationBar()
            // Писваиваем свойству добавление картинки значение true, чтобы оно не менялось на значение по умолчанию
            imageIsChanged = true

            // Создаём вспомогательное свойство и приводим значение data в значение image, чтобы подставить его в оутлет с типом image, и если что то пойдет не так, выходим из метода
            guard let data = currentMedicine?.imageData, let image = UIImage(data: data) else { return }
            
            // Присваиваем полям переданные значения
            medicinesImageIV.image = image
            // Выравниваем изображение, иначе оно будет смотрется очень странно
            medicinesImageIV.contentMode = .scaleAspectFill // масштабирует изображение по содержимому ImageView
            medicinesNameTF.text = currentMedicine?.name
            medicinesTypeTF.text = currentMedicine?.type
            medicinesAmountTF.text = String(currentMedicine!.amount)
            medicinesExpiryDataTF.text = currentMedicine?.expiryDate
        }
    }
    
    // Изменение значений navigationBar для окна редактирования данных
    private func setupNavigationBar() {
        // Убираем название у кнопки возврата, если получается извлеч объект
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        // Убираем кнопку cancel
        navigationItem.leftBarButtonItem = nil
        // Передаём в заголовок текущее название заведения
        title = currentMedicine?.name
        // Активируем кнопку сохранения, так как отсутствия названия быть не может
        saveButtonBBI.isEnabled = true
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
