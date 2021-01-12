//
//  AidKitViewController.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 12.11.2020.
//

import UIKit

class AidKitTableViewController: UITableViewController {
    
    let aidKit = ["Моя Аптечка"]

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
    
    // MARK: - Всплывающее окно приветствия
    // Открываем окно приветствия, после того как основной вью отобразился на экране
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if FirstStartApp.shared.isNewUser() {
            
            // Поддержка iOS младше 12. 13 и старше вместо withIdentifier используется identifier
            if let welcomePageViewController = storyboard?.instantiateViewController(withIdentifier: "WelcomePageViewController") as? WelcomePageViewController {
                // Показываем контроллер приветствия в полный экран, чтобы пользователь не мог закрыть окно и прошел всё описание приложения
                welcomePageViewController.modalPresentationStyle = .fullScreen
                present(welcomePageViewController, animated: true, completion: nil)
                
            }
            
//        }
        
    }
    
//    // MARK: - Всплывающее окно приветствия
//    // Открываем окно приветствия, после того как основной вью отобразился на экране
//    override func viewDidAppear(_ animated: Bool) {
//        if FirstStartApp.shared.isNewUser() {
//            // Показываем окно приветствия
//            if #available(iOS 13.0, *) {
//                let vc = storyboard?.instantiateViewController(identifier: "welcome") as! WelcomeViewController
//                // Показываем контроллер приветствия в полный экран, чтобы пользователь не мог закрыть окно и прошел всё описание приложения
//                vc.modalPresentationStyle = .fullScreen
//                present(vc, animated: true, completion: nil)
//            } else {
//                // Отображение для старых версий
//                let vc = storyboard?.instantiateViewController(withIdentifier: "welcome") as! WelcomeViewController
//                vc.modalPresentationStyle = .fullScreen
//                present(vc, animated: true, completion: nil)
//            }
//        }
//    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Выводим ячейки массива в зависимости от количества записей
        return aidKit.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AidKit", for: indexPath)

        // Конфигурируем ячейки
        cell.backgroundColor = colorBackground // Устанавливаем цвет ячейки из стилей
        // Устанавливаем цвет выбранной ячейки из стилей
        let colorForSelected = UIView()
        colorForSelected.backgroundColor = colorSelected
        cell.selectedBackgroundView? = colorForSelected
        
        cell.textLabel?.text = aidKit[indexPath.row]
        
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
    
    // MARK: Table view delegate
    
    // Отменяем выделение ячейки при возврате на предыдущий экран
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
