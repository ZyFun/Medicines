//
//  MedicinesTableViewController.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 12.11.2020.
//

import UIKit

class MedicinesTableViewController: UITableViewController {
    
    // Подгружаем массив лекарств в таблицу
    let medicines = Medicines.getMedicines()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Конфигурируем стиль таблицы
        self.tableView.tableFooterView = UIView() // Удаляем разделители ячеек
        self.tableView.backgroundColor = colorBackground // Задаём цвет TableView из стилей

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Выводим ячейки массива в зависимости от количества записей
        return medicines.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Medicines", for: indexPath) as! MedicinesTableViewCell // Кастим до описания стиля ячеек
        
        // Конфигурируем стиль ячеек
        cell.backgroundColor = colorBackground // Устанавливаем цвет ячейки из стилей
        // Устанавливаем цвет выбранной ячейки из стилей
        let colorForSelected = UIView()
        colorForSelected.backgroundColor = colorSelected
        cell.selectedBackgroundView? = colorForSelected
        
        // Добавляем данные из массива
        cell.nameLabel.text = medicines[indexPath.row].name
        cell.typeLabel.text = medicines[indexPath.row].type
        cell.expiryDataLabel.text = medicines[indexPath.row].expiryDate
        // Добавляем картинку из массива
        cell.imageMedicines.image = UIImage(named: medicines[indexPath.row].image) // Обращаемся к изображению соотнося имя файла с именем массива
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
    
    // Добавляем возможность выхода из окна (возможно стоит убрать, надо посмотреть другие приложения с всплывающим окном)
    @IBAction func cancelAction (_ segue: UIStoryboardSegue) {}
}
