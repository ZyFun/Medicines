//
//  MedicinesTableViewController.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 12.11.2020.
//

import UIKit
import RealmSwift

class MedicinesTableViewController: UITableViewController {
    // Объект типа Results это аналог массива Swift
    // Results это автообновляемый тип контейнера, который возвращает запрашиваемые объекты
    // Результаты всегда отображают текущее состояние хранилища в текущем потоке в том числе и во время записи транзакций
    // Этот объектр позволяет работать с данными в реальном времени
    // Данный объект можно использовать так же как массив
    // создаём экземпляр модели
    var medicines: Results<Medicine>!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Инициализируем переменную с объектами базы данных и делаем запрос этих объектов из базы данных
        medicines = realm.objects(Medicine.self) // Medicine.self мы пишем, потому что подразумеваем не саму модель данных, а именно тип Medicine
        
        //Конфигурируем стиль таблицы
//        self.tableView.tableFooterView = UIView() // Удаляем разделители ячеек
        self.tableView.backgroundColor = colorBackground // Задаём цвет TableView из стилей

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    // Метод для отображения количества ячеек
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Выводим ячейки массива в зависимости от количества записей, предусматривая возможную пустую базу данных
        return medicines.isEmpty ? 0:medicines.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Medicines", for: indexPath) as! MedicinesTableViewCell // Кастим до описания стиля ячеек
        
        let medicine = medicines[indexPath.row]
        
        // Конфигурируем стиль ячеек
        cell.backgroundColor = colorBackground // Устанавливаем цвет ячейки из стилей
        // Устанавливаем цвет выбранной ячейки из стилей
        let colorForSelected = UIView()
        colorForSelected.backgroundColor = colorSelected
        cell.selectedBackgroundView? = colorForSelected
        
        // Добавляем данные из массива
        cell.nameLabel.text = medicine.name
        cell.typeLabel.text = medicine.type
        cell.expiryDataLabel.text = medicine.expiryDate
        // Добавляем картинку из массива
        cell.imageMedicines.image = UIImage(data: medicine.imageData!) // Заполняем таблицу изображениями принудительно извлекая их, потому что они никогда не будут пустыми
        
        /*
        // Пример кода понадобится (чтобы не забыть) когда я буду добавлять разные фотографии для отображения разных изображений лекарств по умолчанию (спрей, таблетка, сироп)
        if medicine.image == nil {
            cell.imageMedicines.image = UIImage(named: medicine.imageTest!) // если тестовый массив, то бращаемся к изображению соотнося имя файла с именем массива (тестовый вариант массива)
        } else {
            cell.imageMedicines.image = medicine.image // Присваиваем добавленное изображение (основной вариант)
        }
        */
        
        cell.imageMedicines.layer.cornerRadius = 20 //cell.frame.size.height / 2 // Скругляем края
        cell.clipsToBounds = true // Обрезаем для скругления

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Включаем возможность выхода из открывшегося окна обратно на MainView с сохранением данных
    @IBAction func unwindSegue (_ segue: UIStoryboardSegue) {
        // Возвращаем данные полученные с контроллера на котором мы были ранее
        guard let newMedicineVC = segue.source as? NewMedicinesTableViewController else { return }
        // Вызываем метод сохранения данных внесенных изменений
        newMedicineVC.saveNewMedicine()
        // Перезагружаем окно для добавления данных
        tableView.reloadData()
    }
}
