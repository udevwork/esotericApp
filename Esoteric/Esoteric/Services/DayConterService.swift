import Foundation
import WidgetKit
import SwiftDate

class DayConterService {
    
    private let db = UserDefaults(suiteName: "group.esoterica")!
    
    private let streakCountKey = "streakCount"
    private let lastVisitKey = "lastVisitDate"
    
    func copleteThisDay(currentDate: Date = Date()) {
        if let lastVisitDate = db.value(forKey: lastVisitKey) as? Date {
           
            if  lastVisitDate.day != currentDate.day {
                if hasMissedADay(lastVisitDate: lastVisitDate, currentDate: currentDate) {
                    // Если пропущен день, обнуляем счетчик
                    resetStreak()
                    increaseStreak()
                } else {
                    // Иначе увеличиваем счетчик
                    increaseStreak()
                }
            }
        } else {
            // Пользователь заходит в приложение в первый раз
            increaseStreak()
        }
        
        // Сохраняем текущую дату как последнюю дату визита пользователя
        db.set(currentDate, forKey: lastVisitKey)
    }
    
    private func increaseStreak() {
        var currentStreak = db.integer(forKey: streakCountKey)
        currentStreak += 1
        db.set(currentStreak, forKey: streakCountKey)
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func isThisDayCompleted() -> Bool {
        if let lastVisitDate = db.value(forKey: lastVisitKey) as? Date {
            return Calendar.current.isDateInToday(lastVisitDate)
        } else {
            return false
        }
    }
    
    func hasMissedADay(lastVisitDate: Date, currentDate: Date) -> Bool {
        // Проверяем, был ли пропущен хотя бы один день между lastVisitDate и currentDate
        let daysBetween = currentDate - lastVisitDate
        return (daysBetween.day ?? 0) > 1
    }
    
    public func checkIfMissDay(currentDate: Date = Date()) {
      
        if let lastVisitDate = db.value(forKey: lastVisitKey) as? Date {
            if hasMissedADay(lastVisitDate: lastVisitDate, currentDate: currentDate) {
                resetStreak()
            }
        }
      
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func getDayStreak() -> Int {
        return 65 //db.integer(forKey: streakCountKey)
    }
    
    func resetStreak() {
        db.set(0, forKey: streakCountKey)
    }
    
    func deleteAllData() {
        db.removeObject(forKey: streakCountKey)
        db.removeObject(forKey: lastVisitKey)
    }
}
