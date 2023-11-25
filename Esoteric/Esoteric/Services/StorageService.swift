//
//  LocalStorageService.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 19.11.2023.
//

import Foundation
import SwiftDate

enum SavingKeys: String {
    case question
}

final class StorageService {

    private init() {}
    static let shared = StorageService()

    func saveQuestion(text: TarotModel, key: SavingKeys.RawValue) {
        save(text, key: key)
    }

    func loadQuestion(key: SavingKeys.RawValue) -> TarotModel? {
        return load(modelType: TarotModel.self, key: key)
    }

    func clearSavedData() {
        UserDefaults.standard.removeObject(forKey: SavingKeys.question.rawValue)
        UserDefaults.standard.synchronize()
    }

    private func save<T: Codable>(_ object: T, key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            UserDefaults.standard.set(data, forKey: key)
            UserDefaults.standard.synchronize()
        } catch {
            print("\(T.Type.self) saving failed")
        }
    }

    private func load<T>(modelType: T.Type, key: String)  -> T? where T : Codable  {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        do {
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            print("\(T.Type.self) loading failed")
            return nil
        }
    }
}


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
