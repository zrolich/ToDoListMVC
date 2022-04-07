//
//  TableTableViewController.swift
//  ToDoListMVC
//
//  Created by Zhanna Rolich on 06.04.2022.
//

import UIKit


class TableTableViewController: UITableViewController {
    
    
    let model = Model()
    
    var alert = UIAlertController()
    
    class Cell: UITableViewCell{}
    
    @IBOutlet weak var addTask: UIBarButtonItem!
    @IBOutlet weak var editTask: UIBarButtonItem!
    @IBOutlet weak var sortTask: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        
        definesPresentationContext = true
        
        tableView.separatorColor = .blue
        
        title = "My tasks"
        
        model.sortByTitle()
        tableView.reloadData()
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // метод с обращением к модели
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.toDoItems.count
    }
    
    // метод с обращением к модели, заполняющий массив
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyTableCell
        
        let currentItem = model.toDoItems[indexPath.row]
        cell.cellLabel?.text = currentItem.string
        
        return cell
    }
    
    // метод с обращением к модели, удаляющий объект
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            model.toDoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    //метод, обеспечивающий свайп
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal,
                                            title: "Edit") { [weak self] (action, view, completionHandler) in
            self?.editCellContent(indexPath: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = .systemOrange
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    // метод с обращением к модели, вносящий изменения
    func editCellContent(indexPath: IndexPath) {
        
        let cell = tableView(tableView, cellForRowAt: indexPath) as! MyTableCell
        
        alert = UIAlertController(title: "Edit your task", message: nil, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
            textField.text = cell.cellLabel.text
            
        })
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let editAlertAction = UIAlertAction(title: "Submit", style: .default) { (createAlert) in
            
            guard let textFields = self.alert.textFields, textFields.count > 0 else{
                return
            }
            
            guard let textValue = self.alert.textFields?[0].text else {
                return
            }
            
            self.model.updateItem(at: indexPath.row, with: textValue)
            
            self.tableView.reloadData()
            
        }
        
        alert.addAction(cancelAlertAction)
        alert.addAction(editAlertAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func alertTextFieldDidChange(_ sender: UITextField) {
        
        guard let senderText = sender.text, alert.actions.indices.contains(1) else {
            return
        }
        
        let action = alert.actions[1]
        action.isEnabled = senderText.count > 0
    }
    
    //кнопка отрабатывает добавление задания с обращением к модели
    @IBAction func addTaskButton(_ sender: Any) {
        
        alert = UIAlertController(title: "Create new task", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Put your task here"
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
            
        }
        
        let createAlertAction = UIAlertAction(title: "Create", style: .default) { (createAlert) in
            // add new task
            
            guard let unwrTextFieldValue = self.alert.textFields?[0].text else {
                return
            }
            
            self.model.addItem(itemName: unwrTextFieldValue)
            self.model.sortByTitle()
            self.tableView.reloadData()
            
        }
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAlertAction)
        alert.addAction(createAlertAction)
        present(alert, animated: true, completion: nil)
        createAlertAction.isEnabled = false
        
    }
    
    //кнопка отрабатывает изменения задания с обращением к модели
    @IBAction func editButton(_ sender: Any) {
        
        let editOn = UIImage(systemName: "pencil.slash")
        let editOff = UIImage(systemName: "pencil")
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        model.editButtonClicked = !model.editButtonClicked
        editTask.image = model.editButtonClicked ? editOn : editOff
        
    }
    
    //кнопка отрабатывает сортировку заданий с обращением к модели
    @IBAction func sortTaskButton(_ sender: Any) {
        let arrowUp = UIImage(systemName: "arrow.up")
        let arrowDown = UIImage(systemName: "arrow.down")
        
        model.sortedAscending = !model.sortedAscending
        sortTask.image = model.sortedAscending ? arrowUp : arrowDown
        
        model.sortByTitle()
        
        tableView.reloadData()
        
    }
    
    
}
