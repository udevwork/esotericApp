//
//  FortuneTeller.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 19.11.2023.
//

import Foundation
import SwiftDate

class FortuneTeller {
    
    func makeRequest() {
        
    }
    
    func saveResult() {
        
    }
    
    func getResult() {
        
    }
    
    func makeNotification(){
        
    }
    
    func saveTime() {
        let db = UserDefaults.standard
        let date = Date()
        db.set(date, forKey: "date")
    }
    
    func getTime() {
        let db = UserDefaults.standard
        if let date = db.value(forKey: "date") as? Date {
            let diff = Date() - date
            print("Last app use ", diff, "ago")
            if let seconds = diff.second, seconds > 30 {
                print("Ваш расклад готов")
            }
        }
    }
    
    
}
