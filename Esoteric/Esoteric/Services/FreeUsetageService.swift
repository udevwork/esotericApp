import Foundation

class FreeUsetageService {
    
    static let shared = FreeUsetageService()
    private var userDefaultsKey = "FreeUsetageCounter"
    private var counter: Int = 0
    private var free: Int = 30

    private init() {
        if let savedCounter = UserDefaults.standard.value(forKey: userDefaultsKey) as? Int {
            self.counter = savedCounter
        } else {
            self.counter = 0
        }
    }
    
    func incrementCounter() {
        if counter < free {
            counter += 1
            UserDefaults.standard.set(counter, forKey: userDefaultsKey)
        }
    }
    
    func isFreeUseEnd() -> Bool {
        return counter == free
    }
}
