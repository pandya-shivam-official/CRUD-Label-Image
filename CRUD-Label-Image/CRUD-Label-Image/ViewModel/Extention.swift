//
//  Extention.swift
//  CRUD-Label-Image
//
//  Created by Shivam Pandya on 28/04/23.
//

import Foundation
import CoreData
import UIKit

class coredata {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveData(){
        do{
            try self.context.save()
        }
        catch let error{
            print(error)
        }
    }
    
    func getData() -> [Person]{
        
        
        let request = Person.fetchRequest() as NSFetchRequest<Person>
        
        return try! context.fetch(request)
    }
    
    func addData(data:String, data2:Data){
        let newPerson = Person(context: self.context)
        newPerson.name = data
        newPerson.photo = data2
    }
    
    func updateData(data:Person, text:String, img:Data){
        let person =  data
        person.name = text
        person.photo = img
    }
    
    func deleteData(dataToRemove:Person){
        self.context.delete(dataToRemove)
    }
}
