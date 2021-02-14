//
//  MedicinesTableViewController.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 12.11.2020.
//

import UIKit
import RealmSwift

class MedicinesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reversedSortingBBI: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Properties
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
    // Создаём свойство, для подсчета просроченных лекарств
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
    
    // Создаём экземпляр класса, для отправки уведомлений
    private let notifications = Notifications()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Способ установки значка на таб бар контроллер. Массив это экраны таб бар контроллера
        // Отображает бейдж на кнопке "напоминания"
        tabBarController?.tabBar.items?[1].badgeValue = "Скоро"
        
        // Инициализируем переменную с объектами базы данных и делаем запрос этих объектов из базы данных
        medicines = realm.objects(Medicine.self) // Medicine.self мы пишем, потому что подразумеваем не саму модель данных, а именно тип Medicine
        
        setupBadgeForAppIcon() // Вызываем метод, чтобы обновить бейджи на иконке приложения во время загрузки
        
        updateNotificationQueueExpiredMedicine() // Вызываем метод, чтобы загрузить уведомления
        
        // Создаётся пример объекта при мервом запуске приложения, и если база пустая
        if FirstStartApp.shared.isFirstOpenAidKit() {
            
            FirstStartApp.shared.learningNewObjectGet()
            FirstStartApp.shared.setIsNotFirstOpenAidKit()
            
        }
        
        // MARK: Style config
        tableView.tableFooterView = UIView() // Удаляем разделители ячеек
        
        tableView.backgroundColor = .customColor(light: UIColor.Light.background,
                                                 dark: UIColor.Dark.background)
        
        view.backgroundColor = .customColor(light: UIColor.Light.background,
                                            dark: UIColor.Dark.background)
        
        // Задаём цвет фона в navigationController
        navigationController?.navigationBar.barTintColor = .customColor(light: UIColor.Light.navigationBar,
                                                                        dark: UIColor.Dark.navigationBar)
        // Задаём цвета надписей и стрелок в navigationController
        navigationController?.navigationBar.tintColor = .customColor(light: UIColor.Light.icon,
                                                                     dark: UIColor.Dark.icon)
        // Задаём цвет фона в tabBarController
        tabBarController?.tabBar.barTintColor = .customColor(light: UIColor.Light.navigationBar,
                                                             dark: UIColor.Dark.navigationBar)
        // Задаём цвет надписей и иконок кнопок в tabBarController
        tabBarController?.tabBar.tintColor = .customColor(light: UIColor.Light.icon,
                                                          dark: UIColor.Dark.icon)
        
        if #available(iOS 13.0, *) {
            // Задаём цвет фона активного сегмента
            segmentedControl.selectedSegmentTintColor = .customColor(light: UIColor.Light.selected,
                                                                     dark: UIColor.Dark.selected)
        } else {
            // Этот цвет учше подходит для старых версий
            segmentedControl.tintColor = .customColor(light: UIColor.Light.icon,
                                                      dark: UIColor.Dark.icon)
        }
        
        // MARK: Search controller setup
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
    }
    
    // Открываем окно приветствия, после того как основной вью отобразился на экране
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // MARK: Всплывающее окно приветствия
        if FirstStartApp.shared.isNewUser() {
            
            // Поддержка iOS младше 12. 13 и старше вместо withIdentifier используется identifier
            if let welcomePageViewController = storyboard?.instantiateViewController(withIdentifier: "WelcomePageViewController") as? WelcomePageViewController {
                // Показываем контроллер приветствия в полный экран, чтобы пользователь не мог закрыть окно и прошел всё описание приложения
                welcomePageViewController.modalPresentationStyle = .fullScreen
                present(welcomePageViewController, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    // MARK: Close view and app
    // TODO: Требуется тестирование, чтобы понять нужно мне вызывать этот метод тут или нет. К примеру воспроизвести момент, когда приложение свернуто но не закрыто, а лекарство просрочилось. Вероятнее всего приложение будет всернуто долгое время. Нужно посмотреть как поведет себя загрузка через час. Так как памяти оно много не тратит и может быть долго не выгружено
    override func viewDidDisappear(_ animated: Bool) {
        
        setupBadgeForAppIcon() // Вызываем метод, чтобы обновить бейджи на иконке приложения после закрытия приложения.
        
    }
    

    // MARK: - Table view data source

    // Метод для отображения количества ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Логика отображения данных в случае поиска данных пользователем если поисковая строка активна
        if isFiltering {
            // Отображаем количество элементов массива filteredPlaces
            return filteredMedisines.count
        } else {
            // Выводим ячейки массива в зависимости от количества записей
            return medicines.count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Medicines", for: indexPath) as! MedicinesTableViewCell // Кастим до описания стиля ячеек
        
        // Экземпляр класса, для написания логики выводимых данных при поиске или без него и для активации/девктивации Segmented Control
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
        cell.backgroundColor = .customColor(light: UIColor.Light.background,
                                            dark: UIColor.Dark.background) // Устанавливаем цвет ячейки
        // Устанавливаем цвет выбранной ячейки из стилей
        let colorForSelected = UIView()
        colorForSelected.backgroundColor = .customColor(light: UIColor.Light.selected,
                                                        dark: UIColor.Dark.selected)
        cell.selectedBackgroundView? = colorForSelected
        
        // Добавляем данные из массива
        cell.nameLabel.text = medicine.name
        cell.typeLabel.text = medicine.type
        cell.expiryDataLabel.text = medicine.expiryDate?.toString()
        // Добавляем картинку из массива
        cell.imageMedicines.image = UIImage(data: medicine.imageData!) // Заполняем таблицу изображениями принудительно извлекая их, потому что они никогда не будут пустыми
        cell.amountLabel.text = "\(medicine.amount) шт"
        
        // Показываем иконку просроченного лекарства, если не просрочено и не указана дата, оставляем иконку скрытой
        cell.trashLabel.isHidden = true
        if Date() >= medicine.expiryDate ?? Date() {
            cell.trashLabel.isHidden = false
        }

        /*
        // TODO: Пример кода понадобится (чтобы не забыть) когда я буду добавлять разные фотографии для отображения разных изображений лекарств по умолчанию (спрей, таблетка, сироп)
        if medicine.image == nil {
            cell.imageMedicines.image = UIImage(named: medicine.imageTest!) // если тестовый массив, то бращаемся к изображению соотнося имя файла с именем массива (тестовый вариант массива)
        } else {
            cell.imageMedicines.image = medicine.image // Присваиваем добавленное изображение (основной вариант)
        }
        */
        return cell
    }
    
    //MARK: - Table view delegate
    
    //Отменяем выделение ячейки при возврате на предыдущий экран
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
    // TODO: Использовать этот метод, когда потребуется дополнительный функциоанл
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
        
        // Экземпляр класса, для написания логики правильного удаления из таблицы базы данных
        var medicine = Medicine()

        // Настраиваем стиль и правильное удаление ячейки, в зависимости от того, фильтруется она или нет
        if editingStyle == .delete {
            if isFiltering {
                // создаём объект для удаления из особого массива с фильтрацией
                medicine = filteredMedisines[indexPath.row]
                notifications.notificationCenter.removePendingNotificationRequests(withIdentifiers: [medicine.name]) // Удаляем уведомление по идентификатору, чтобы оно не показывалось в будущем
                // Вызываем действие удаления из базы
                StorageManager.deleteObject(medicine)
                // Удаляем строку из приложения
                tableView.deleteRows(at: [indexPath], with: .automatic)
                setupBadgeForAppIcon() // Вызываем метод, чтобы обновить бейджи на иконке приложения после удаления предположительно просроченного лекарства
            } else {
                // создаём объект для удаления из массива
                medicine = medicines[indexPath.row]
                // Вызываем действие удаления из базы
                notifications.notificationCenter.removePendingNotificationRequests(withIdentifiers: [medicine.name]) // Удаляем уведомление по идентификатору, чтобы оно не показывалось в будущем
                StorageManager.deleteObject(medicine)
                // Удаляем строку из приложения
                tableView.deleteRows(at: [indexPath], with: .automatic)
                setupBadgeForAppIcon() // Вызываем метод, чтобы обновить бейджи на иконке приложения после удаления предположительно просроченного лекарства
            }
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
            // Извлекаем объект по этому индексу с фильтрацией
            let medicine = isFiltering ? filteredMedisines[indexPath.row] : medicines[indexPath.row]
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
        newMedicineVC.saveMedicine() // Вызываем метод сохранения данных внесенных изменений
        updateNotificationQueueExpiredMedicine() // Обновляем очередь уведомлений, чтобы добавить в него новое лекарство
        setupBadgeForAppIcon() // Обновляем бейджы после сохранения, так как добавить могут уже просроченные лекарства (не у всех есть возможность купить новые)
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
    
    // MARK: - Functions
    /// Метод смены способа сортировки
    /// - Сортировка настраивается через segmented control. В зависимости от индекса выбранного сегмента, сортировка происходит по ключу базы
    private func sorting() {
        if segmentedControl.selectedSegmentIndex == 0 {
            medicines = medicines.sorted(byKeyPath: "date", ascending: ascendingSorted) // По дате добавления
        } else if segmentedControl.selectedSegmentIndex == 1{
            medicines = medicines.sorted(byKeyPath: "name", ascending: ascendingSorted) // По названию лекарства
        } else {
            medicines = medicines.sorted(byKeyPath: "expiryDate", ascending: ascendingSorted) // По сроку годности
        }
        
        tableView.reloadData() // Обновляем данные в таблице
    }
    
    /// Метод установки бейджа с количеством просроченных лекарств на иконку приложения.
    /// - Установка бейджа на иконку: функция пробегается циклом по массиву лекарств. И если в базе есть лекарства с просроченным сроком годности, то добавляется +1 к значению на бейдже за каждое лекарство с просроченным сроком годности. Если таких лекарств нет, бейдж сбрасывается на 0.
    private func setupBadgeForAppIcon() {
        
        var expiredMedicinesCount = 0 // Создаём свойство, для подсчета просроченных лекарств
        
        for medicine in medicines { // Проходимся циклом по массиву базы лекарств и прибавляем +1 к счетчику
            
            if Date() >= medicine.expiryDate ?? Date() { // Если есть просроченное лекарство делаем +1.
                
                expiredMedicinesCount += 1
                notifications.setupBadge(count: expiredMedicinesCount) // Отправляем это значение в метод класса уведомлений
                
            } else {
                notifications.setupBadge(count: expiredMedicinesCount) // Если просрочек нет, сбрасываем на 0. То есть присваиваем изначальное значение равное 0
            }
        }
    }
    
    /// Метод для обновления очереди уведомлений.
    /// - Добавление в очередь центра уведомлений: функция пробегается циклом по массиву лекарств и получает данные с именем лекарства и датой срока его годности. Далее эти данные принимаются функцией sendNotificationExpiredMedicine в классе Notifications и добавляются в очередь уведомлений.
    private func updateNotificationQueueExpiredMedicine() {
        
        for medicine in medicines {
            notifications.sendNotificationExpiredMedicine(reminder: medicine.expiryDate, nameMedicine: medicine.name)
            
        }
    }
}

// MARK: - SearchController

// Расширение класса для настройки фильтрации поиска
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
