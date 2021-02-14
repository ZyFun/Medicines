//
//  TakingMedicineTableViewController.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 08.02.2021.
//
// Задокументированно

import UIKit

class TakingMedicineTableViewController: UITableViewController {

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Style config
        
        // Удаляем разделители ячеек
        tableView.tableFooterView = UIView()
        
        // Задаём цвет фона
        tableView.backgroundColor = .customColor(light: UIColor.Light.background,
                                                 dark: UIColor.Dark.background)
        view.backgroundColor = .customColor(light: UIColor.Light.background,
                                            dark: UIColor.Dark.background)
        navigationController?.navigationBar.barTintColor = .customColor(light: UIColor.Light.navigationBar,
                                                                        dark: UIColor.Dark.navigationBar)
        tabBarController?.tabBar.barTintColor = .customColor(light: UIColor.Light.navigationBar,
                                                             dark: UIColor.Dark.navigationBar)
        
        // Задаём цвета надписей и иконок
        navigationController?.navigationBar.tintColor = .customColor(light: UIColor.Light.icon,
                                                                     dark: UIColor.Dark.icon)
        tabBarController?.tabBar.tintColor = .customColor(light: UIColor.Light.icon,
                                                          dark: UIColor.Dark.icon)
        
        // Задаём значение текста
        navigationItem.title = "Принять лекарства"
        
        alertDeveloping()
    }
    
    // MARK: - Functions
    
    /// Временный метод для отображения алерта с сообщением о том, что раздел в разработке
    private func alertDeveloping() {
        let alert = UIAlertController(title: "Скоро",
                                      message: "Раздел еще в разработке. Тут можно будет создавать напоминания о приёме лекарств, выбирая лекарство из имеющихся в аптечке",
                                      preferredStyle: .alert)

        let okButton = UIAlertAction(title: "Ok", style: .default)

        alert.addAction(okButton)
        
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

}
