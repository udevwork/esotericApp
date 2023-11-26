import Foundation
import WidgetKit

class DayConterService {
    
    let db = UserDefaults(suiteName: "group.esoterica")
    let key = "dayCounter"
    
    func copleteThisDay() {
        if let db = db {
            var counter = db.integer(forKey: key)
            counter += 1
            db.set(counter, forKey: key)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    func isThisDayCompleted() {
        
    }
    
    func getDayCont() -> Int {
        if let db = db {
            return db.integer(forKey: key)
        }
        return -1
    }
    
    func clearDayCont() {
        if let db = db {
            db.set(0, forKey: key)
        }
    }
}
