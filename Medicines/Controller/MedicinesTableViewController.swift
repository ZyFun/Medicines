//
//  MedicinesTableViewController.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 12.11.2020.
//

import UIKit
import RealmSwift

class MedicinesTableViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reversedSortingBBI: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // Объявляем экземпляр класса searchController
    // Используя параметр nil, результаты поиска будут отображаться в том же окне
    // Для этого необходимо подписать текущий класс под протокол UISearchResultsUpdating
    private let searchController = UISearchController(searchResultsController: nil)
    // Массив для отображения отфильрованных записей
    private var filteredMedisines: Results<Medicine>!
    // Вспомагательное свойство для строки поиска. Должна возвращать значение true если строка поиска пустая
    private var searchBarIsEmpty: Bool {
        // Безопасно пытаемся извлечь значение
        guard let text = searchController.searchBar.text else { return false}
        return text.isEmpty
    }
    // Вспомогательное свойство для отслеживания воода текста в поисковую строку
    private var isFiltering: Bool {
        // Поисковая строка активирована и не является пустой
        return searchController.isActive && !searchBarIsEmpty
    }
    // Объект типа Results это аналог массива Swift
    // Results это автообновляемый тип контейнера, который возвращает запрашиваемые объекты
    // Результаты всегда отображают текущее состояние хранилища в текущем потоке в том числе и во время записи транзакций
    // Этот объектр позволяет работать с данными в реальном времени
    // Данный объект можно использовать так же как массив
    // создаём экземпляр модели
    private var medicines: Results<Medicine>!
    // Вспомогательное свойство для обратной сортировки, по умолчанию сортировка делается по возростанию
    private var ascendingSorted = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Инициализируем переменную с объектами базы данных и делаем запрос этих объектов из базы данных
        medicines = realm.objects(Medicine.self) // Medicine.self мы пишем, потому что подразумеваем не саму модель данных, а именно тип Medicine
        
        // Временное решение. Создаётся новый объект при пустой базе данных для обучения пользователя
        learningNewObjectGet()
        
        //Конфигурируем стиль таблицы
//        self.tableView.tableFooterView = UIView() // Удаляем разделители ячеек
        tableView.backgroundColor = colorBackground // Задаём цвет TableView из стилей
        view.backgroundColor = colorBackground
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = colorSelected
        } else {
            // Fallback on earlier versions
            // Цвет берется из настройки через интерфейс
            segmentedControl.tintColor = colorSelected
        }
        
        // Настройка searchController
        // Указываем на то, что получателем информации об изменении текста в поисковой строке должен быть наш класс
        searchController.searchResultsUpdater = self
        // Позволяет взяимодействовать с новым вью контроллером как с основным и получать доступ к редактированию или удалению. По умолчанию это отключено.
        searchController.obscuresBackgroundDuringPresentation = false
        // Присваиваем плейсхолдер для отображения в строке поиска
        searchController.searchBar.placeholder = "Найти"
        // Интрегрируем строку поиска в navigationBar
        navigationItem.searchController = searchController
        // Отпускаем строку поиска при переходе на другой экран
        definesPresentationContext = true
        
//        // TODO: Welcome window
//        let userDefaults = UserDefaults.standard
//
//        let isFristOpen = userDefaults.bool(forKey: "isFristOpenApp")
//
//                if isFristOpen == true {
//                    if let welcomeController = storyboard?.instantiateViewControllerWithIdentifier("WelcomeController") as? WelcomeController {
//
//                        self.presentViewController(welcomeController , animated: true, completion: nil)
//                    }
//
//                }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    // Метод для отображения количества ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Логика отображения данных в случае поиска данных пользователем если поисковая строка активна
        if isFiltering {
            // Отображаем количество элементов массива filteredPlaces
            return filteredMedisines.count
        } else {
            // Выводим ячейки массива в зависимости от количества записей, предусматривая возможную пустую базу данных
            return medicines.isEmpty ? 0:medicines.count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Medicines", for: indexPath) as! MedicinesTableViewCell // Кастим до описания стиля ячеек
        
        // Экземпляр класса, для написания логики выводимых данных при поиске или без него
        var medicine = Medicine()
        
        // Присваиваем значение в зависимости от активации строки поиска. Либо это будет результат поиска, либо данные из базы данных без фильтрации
        if isFiltering {
            // Отключаем панель сортировки, потому что она тут не нужна. Логику работы еще не написал и не буду
            segmentedControl.isEnabled = false
            medicine = filteredMedisines[indexPath.row]
        } else {
            // Включаем панель сортировка для общего массива
            segmentedControl.isEnabled = true
            medicine = medicines[indexPath.row]
        }
        
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
        cell.amountLabel.text = "Кол-во: \(medicine.amount)"
        
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
    
    //MARK: - Table view delegate
    
    /*
    // Метод позволяет настроить пользовательские действия, при свайпе ячейки с права на лево
    // leadingSwipeActionsConfigurationForRowAt для действий с лева на право
    // Этот метод используется для множества действий, по этому для нас он избыточен
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Создаём действие удаления строки
        // style отображает цвет действия
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            // Создаём объект для удаления из массива
            let place = self.places[indexPath.row]
            // Вызываем действие удаления из базы
            StorageManager.delitObject(place)
            // Удаляем строку в приложении
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        // Передаём массив с контекстными действиями
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    */
    
    // Создаём метод для удаления строки
    // Этим методом можно либо удалять, либо добавлять строки
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Настраиваем стиль
        if editingStyle == .delete {
            // создаём объект для удаления из массива
            let medicine = medicines[indexPath.row]
            // Вызываем действие удаления из базы
            StorageManager.deleteObject(medicine)
            // Удаляем строку из приложения
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
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

    // MARK: - Navigation

    // Подготовка перехода на другой экран
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Подготовка информации по идентификатору сегвея
        if segue.identifier == "showDetail" {
            // Извлекаем значение индекса из выбранной ячейки, если оно есть иначе выходим из метода
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            // Экземпляр модели, для фильтрации
            let medicine: Medicine
            
            // Извлекаем объект по этому индексу
            if isFiltering {
                medicine = filteredMedisines[indexPath.row]
            } else {
                medicine = medicines[indexPath.row]
            }
            
            // Создаём экземпляр вью контроллера на который передаём значение, выбирая контроллер назначения принудительно извлекая опционал
            let newMedicinesVC = segue.destination as! NewMedicinesTableViewController
            // Обращаемся к экземпляру контроллера и его свойству, в которое будем передавать значение и присваиваем ему извлеченный по индексу объект
            newMedicinesVC.currentMedicine = medicine
        }
    }
    // MARK: - Actions
    // Включаем возможность выхода из открывшегося окна обратно на MainView с сохранением данных
    @IBAction func unwindSegue (_ segue: UIStoryboardSegue) {
        // Возвращаем данные полученные с контроллера на котором мы были ранее
        guard let newMedicineVC = segue.source as? NewMedicinesTableViewController else { return }
        // Вызываем метод сохранения данных внесенных изменений
        newMedicineVC.saveMedicine()
        // Перезагружаем окно для добавления данных
        tableView.reloadData()
    }
    @IBAction func reversedSorting(_ sender: Any) {
        // Меняем значение на противоположное
        ascendingSorted.toggle()
        
        // Меняем значение изображения (переворачиваем стрелочки)
        if ascendingSorted {
            reversedSortingBBI.image = #imageLiteral(resourceName: "AZ")
        } else {
            reversedSortingBBI.image = #imageLiteral(resourceName: "ZA")
        }
        
        // Вызываем метод сортировки
        sorting()
        
    }
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        // Вызываем метод сортировки
        sorting()
    }
    
    // Метод смены способа сортировки
    private func sorting() {
        if segmentedControl.selectedSegmentIndex == 0 {
            medicines = medicines.sorted(byKeyPath: "date", ascending: ascendingSorted)
        } else if segmentedControl.selectedSegmentIndex == 1{
            medicines = medicines.sorted(byKeyPath: "name", ascending: ascendingSorted)
        } else {
            medicines = medicines.sorted(byKeyPath: "expiryDate", ascending: ascendingSorted)
        }
        
        // Обновляем данные в таблице
        tableView.reloadData()
    }
}

// MARK: - SearchController

// Настройка фильтрации поиска
extension MedicinesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Вызываем метод фильтрации, и подставляем в параметр значение поисковой строки
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    // Метод для фильтрации контента в соответствии с поисковым запросом
    private func filterContentForSearchText (_ searchText: String) {
        // Заполняем коллекцию отфильтрованными объектами из основного массива. Поиск выполняется по двум полям, адресу и имени заведения
        // Поиск не должен зависеть от регистра символов "CONTAINS[c]"
        // Выражение означает что мы должны будем волнять поиск по полям name и lokation и фильтровать данные по значению параметра searchText в независимости от регистра символов
        // Надо разобраться подробнее в документации, как работает такая фильтрация
        filteredMedisines = medicines.filter("name CONTAINS[c] %@ OR type CONTAINS[c] %@", searchText, searchText)
        
        // Обновляем значения табличного представления
        tableView.reloadData()
    }
    
}
