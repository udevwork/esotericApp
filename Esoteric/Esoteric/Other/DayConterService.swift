import Foundation
import WidgetKit

class DayConterService {
    
    private let db = UserDefaults(suiteName: "group.esoterica")!
    
    private let streakCountKey = "streakCount"
    private let lastVisitKey = "lastVisitDate"
    
    func copleteThisDay() {
        let currentDate = Date()
        
        if let lastVisitDate = db.value(forKey: lastVisitKey) as? Date {
            if !Calendar.current.isDateInToday(lastVisitDate) {
                if hasMissedADay(lastVisitDate: lastVisitDate, currentDate: currentDate) {
                    // Если пропущен день, обнуляем счетчик
                    resetStreak()
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
    
    private func hasMissedADay(lastVisitDate: Date, currentDate: Date) -> Bool {
        // Проверяем, был ли пропущен хотя бы один день между lastVisitDate и currentDate
        let calendar = Calendar.current
        let daysBetween = calendar.dateComponents([.day], from: lastVisitDate, to: currentDate).day ?? 0
        return daysBetween > 1
    }
    
    func getDayStreak() -> Int {
        return db.integer(forKey: streakCountKey)
    }
    
    func resetStreak() {
        db.set(0, forKey: streakCountKey)
    }
}
