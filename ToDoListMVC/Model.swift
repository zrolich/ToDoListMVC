//
//  Model.swift
//  ToDoListMVC
//
//  Created by Zhanna Rolich on 06.04.2022.
//

import Foundation
import UIKit

class Item {
    
    //так как кнопок по заданию на ячейке нет, поэтому объект имеет только один параметр
    
    var string: String
    
    init(string: String) {
        self.string = string
        
    }
}

class Model {
    
    // свойство кнопки, вносящей изменения
    
    var editButtonClicked: Bool = false
    
    //массив заданий
    
    var toDoItems: [Item] = [
        Item(string: "Task1"),
        Item(string: "Task2"),
        Item(string: "Task3"),
    ]
    
    //свойство для кнопки сортировки
    
    var sortedAscending: Bool = true
    
    //метод добавления нового объекта

    func addItem(itemName: String) {
        toDoItems.append(Item(string: itemName))
    }
    
    //метод удаления объекта
    
    func removeItem(at index: Int) {
        toDoItems.remove(at: index)
    }
 
    // метод перезаписывания значений

    func updateItem(at index: Int, with string: String) {
        toDoItems[index].string = string
    }

    // метод для сортировки
    
    func sortByTitle() {
        toDoItems.sort {
            sortedAscending ? $0.string < $1.string : $0.string > $1.string
        }
    }
    
}
