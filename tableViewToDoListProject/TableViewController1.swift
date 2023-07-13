//
//  TableViewController1.swift
//  tableViewToDoListProject
//
//  Created by Syrym Khamzin on 10.04.2023.
//

import UIKit

// HW
// Создать 2 экранное TableView приложение - список задач
// На первом экране, должен отображаться список Ваших задач
// Возможности: Добавить задачу, Удалить задачу и посмотреть задачу
// Второй экран - нужен для просмотра дополнительной информации о задаче, например дата создания задачи, комментарий
// На первом экране - должен поиск

// План Cоздания Приложения
/*
 1. создать метод filter в TVC1
 2. Дописать time picker в TVC1
 3. Создать метод для передачи данных с TVC1 в TVC2
 */

class TableViewController1: UITableViewController {
    
    @IBOutlet weak var myLabel: UILabel!
    
    var myTasks = [DataStructures]()
    var myTasksBackup = [DataStructures]()
    
    var saveLoadData = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        myTasksBackup = myTasks
        
        barButtonsForAddDelete()
        searchBarSetup()
        refreshTableView()
        loadData()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    func randomID() -> Int {
        var r = Int.random(in: 1...100_000)
        
        if myTasks.filter({$0.id == r}).isEmpty {
            print("RANDOM ID", r)
            return r
        }
        
        for _ in 1...100 {
            r = Int.random(in: 1...100_000)
            if myTasks.filter({$0.id == r}).isEmpty {
                print("RANDOM ID", r)
                return r
            }
        }
        
        print("RANDOM ID", r)
        return r
    }
    
    func barButtonsForAddDelete() {
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        addBarButton.tintColor = .red
        navigationItem.rightBarButtonItem = addBarButton
        
        let deleteBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTask))
        deleteBarButton.tintColor = .red
        navigationItem.leftBarButtonItem = deleteBarButton
    }
    
    @objc func addTask() {
        let alert = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        let add = UIAlertAction(title: "Add", style: .destructive) { [self] _ in
            
            if let textFieldTask = alert.textFields?.first,
               let textFieldComment = alert.textFields?.last {
                
                if textFieldTask.text?.isEmpty == false && textFieldComment.text?.isEmpty == false {
                    
                    myTasks.append(DataStructures(id: (randomID()), title: textFieldTask.text ?? "", date: currentDate(), time: currentTime(), comments: textFieldComment.text ?? ""))
                    
                    myTasksBackup = myTasks
                    tableView.reloadData()
                    refreshTableView()
                    saveData()
                    print(myTasks)
                }
            }
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Add a task"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Add comment"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(add)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func currentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: Date())
    }
    
    func currentTime() -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        return timeFormatter.string(from: Date())
    }
    
    @objc func deleteTask() {
        if myTasks.isEmpty == true {
            let alert = UIAlertController(title: "You don't have any task to delete", message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .cancel)
            
            alert.addAction(cancel)
            present(alert, animated: true)
            
        } else {
            let alert = UIAlertController(title: "Delete Task", message: nil, preferredStyle: .alert)
            let delete = UIAlertAction(title: "Delete", style: .destructive) { [self] _ in
                myTasks.removeAll(where: {$0.selected == true})
                
                myTasksBackup = myTasks
                tableView.reloadData()
                refreshTableView()
                saveData()
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(delete)
            alert.addAction(cancel)
            present(alert, animated: true)
        }
    }
    
    func refreshTableView() {
        myLabel.frame.size.height = 150
        myLabel.font = .systemFont(ofSize: 20, weight: .medium)
        
        switch myTasks.count {
        case 0:
            title = "My To-Do List"
            myLabel.text = "Press '+' Button to Add a New Task"
        default:
            title = "You Have '\(myTasks.count)' Tasks"
            myLabel.text = ""
        }
    }
    
    func clickToDisplay(indexPathRow: Int) {
        
        let alert = UIAlertController(title: "You selected", message: "\(myTasks[indexPathRow].title)", preferredStyle: .alert)
        let openInVC = UIAlertAction(title: "Open in VC", style: .destructive) { [self] _ in
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            if let nextView = storyBoard.instantiateViewController(withIdentifier: "ViewControllerForDetailsView") as? ViewControllerForDetailsView {
                let data = myTasks[indexPathRow]
                
                nextView.titleFromTVC = data.title
                nextView.dateFromTVC = data.date
                nextView.timeFromTVC = data.time
                nextView.commentsFromTVC = data.comments
                
                navigationController?.pushViewController(nextView, animated: true)
            }
        }
        
        let openInTVC = UIAlertAction(title: "Open in TVC", style: .destructive) { [self] _ in
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            if let nextTVC = storyBoard.instantiateViewController(withIdentifier: "TableViewControllerForDetailsView") as? TableViewControllerForDetailsView {
                let data = myTasks[indexPathRow]
                
                nextTVC.titleFromTVC = data.title
                nextTVC.dateFromTVC = data.date
                nextTVC.timeFromTVC = data.time
                nextTVC.commentsFromTVC = data.comments
                
                navigationController?.pushViewController(nextTVC, animated: true)
            }
        }
        
        let highlighted = UIAlertAction(title: "Selected / Unselected", style: .default) {[self] _ in
            myTasks[indexPathRow].selected.toggle()
            tableView.reloadData()
            saveData()
        }
        
        let cancel = UIAlertAction(title: "OK", style: .cancel)
        
        alert.addAction(openInVC)
        alert.addAction(openInTVC)
        alert.addAction(highlighted)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func saveData() {
        saveLoadData.set(try? PropertyListEncoder().encode(myTasks), forKey: "save")
    }
    
    func loadData() {
        if let getData = saveLoadData.value(forKey: "save") as? Data {
            if let decodeData = try? PropertyListDecoder().decode(Array<DataStructures>.self, from: getData) {
                myTasks = decodeData
                myTasksBackup = decodeData
            } else {
                print("Data decode not available")
            }
            
        } else {
            print("No Data")
        }
        
        refreshTableView()
    }
    
    func searchBarSetup() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        
        searchBar.delegate = self
        searchBar.tintColor = .red
        searchBar.barTintColor = .white
        searchBar.prompt = "Enter"
        searchBar.searchTextField.textColor = .red
        searchBar.placeholder = "Search"
        tableView.tableHeaderView = searchBar
    }
    
    func searchFilter(text: String) {
        myTasks = myTasksBackup.filter({ task in
            return task.title.lowercased().contains(text.lowercased())
        })
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let data = myTasks[indexPath.row]
        
        var customCell = cell.defaultContentConfiguration()
        
        customCell.text = data.title
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .black
            customCell.textProperties.color = .white
        } else {
            cell.backgroundColor = .white
            customCell.textProperties.color = .black
        }
        
        if data.selected == true {
            cell.accessoryType = .checkmark
            cell.tintColor = .red
        } else {
            cell.accessoryType = .none
        }
        
        cell.contentConfiguration = customCell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickToDisplay(indexPathRow: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if myTasks.isEmpty {
                return nil
            }
            return "TASKS SECTION"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let id = myTasks[indexPath.row].id
            myTasks.remove(at: indexPath.row)
            myTasksBackup.removeAll(where: {$0.id == id})
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            myTasksBackup = myTasks
            saveData()
            refreshTableView()
            
        } else if editingStyle == .insert {
        }
    }
}

extension TableViewController1: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        
        myTasks = myTasksBackup
        
        searchBar.text = nil
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == false {
            let text = searchText.lowercased().trimmingCharacters(in: .whitespaces)
            searchFilter(text: text)
        } else {
            myTasks = myTasksBackup
            tableView.reloadData()
        }
        
        if searchText.isEmpty == false && myTasks.isEmpty {
            myLabel.text = "Was not Found!"
        } else if searchText.isEmpty && myTasks.isEmpty {
            myLabel.text = nil
        } else if searchText.isEmpty && myTasks.isEmpty == false {
            myLabel.text = nil
        } else if searchText.isEmpty == false && myTasks.isEmpty == false {
            myLabel.text = nil
        }
    }
}

// Questions
// Галочки не появляются (checkmark и none)
// Если использую userDefaults для сохранения данных, во время запуска switch case 0 не работает
// Методы сохранить и загрузить не работают

// Questions
// Решил делать проект с одним TVC и одним VC (для начала)
// После нажатия на "cancel" в searchBar, элементы не появляются (необходимо нажать на 'x'). Нормально ли это?

// Questions
// Верно ли я сделал проект с TVC, не настроив его?
// Почему я не вижу header в TableViewControllerForDetailsView?
// Можно ли переделать проект, убрав id? Стоит ли так делать? 
