//
//  EsotericTests.swift
//  EsotericTests
//
//  Created by Denis Kotelnikov on 06.12.2023.
//  https://habr.com/ru/articles/654591/

import XCTest
import SwiftDate

final class EsotericTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let counter = DayConterService()
        counter.deleteAllData()
        XCTAssertEqual(counter.getDayStreak(), 0, "Первый запуск приложения")
        
        var currentDay = "2023-05-20 15:30:00".toDate()!.date
        var lastVisitDay = "2023-05-22 00:01:00".toDate()!.date
        
        counter.copleteThisDay(currentDate: currentDay)
        XCTAssertEqual(counter.getDayStreak(), 1, "День пройден")
        
        counter.copleteThisDay(currentDate: currentDay)
        XCTAssertEqual(counter.getDayStreak(), 1, "То же самое время")
        
        currentDay = "2023-05-20 21:30:00".toDate()!.date
        counter.copleteThisDay(currentDate: currentDay)
        XCTAssertEqual(counter.getDayStreak(), 1, "Счетчик в том же дне не увеличивается")
        
        currentDay = "2023-05-21 15:30:00".toDate()!.date
        counter.copleteThisDay(currentDate: currentDay)
        XCTAssertEqual(counter.getDayStreak(), 2, "Новый день")
        
        currentDay = "2023-05-22 00:01:00".toDate()!.date
        counter.copleteThisDay(currentDate: currentDay)
        XCTAssertEqual(counter.getDayStreak(), 3, "Новый день")
    
        currentDay = "2023-05-22 00:01:00".toDate()!.date
        counter.checkIfMissDay(currentDate: currentDay)
        XCTAssertEqual(counter.getDayStreak(), 3, "Не должен сброситися")
        
        currentDay = "2023-05-23 00:01:00".toDate()!.date
        counter.checkIfMissDay(currentDate: currentDay)
        XCTAssertEqual(counter.getDayStreak(), 3, "Не должен сброситися")
        
        currentDay = "2023-05-24 00:01:00".toDate()!.date
        counter.checkIfMissDay(currentDate: currentDay)
        XCTAssertEqual(counter.getDayStreak(), 0, "Должен сброситися")
        
        currentDay = "2023-05-25 00:01:00".toDate()!.date
        counter.checkIfMissDay(currentDate: currentDay)
        XCTAssertEqual(counter.getDayStreak(), 0, "Должен сброситися")
        
        currentDay = "2023-05-30 00:01:00".toDate()!.date
        counter.copleteThisDay(currentDate: currentDay)
        XCTAssertEqual(counter.getDayStreak(), 1, "День пройден")
        
        currentDay = "2023-06-3 00:01:00".toDate()!.date
        counter.copleteThisDay(currentDate: currentDay)
        XCTAssertEqual(counter.getDayStreak(), 1, "Был большой перерыв с прошлого раза")
        
        currentDay = "2023-07-3 00:01:00".toDate()!.date
        counter.copleteThisDay(currentDate: currentDay)
        XCTAssertEqual(counter.getDayStreak(), 1, "Тот же день, но другой месяц")

        currentDay = "2023-07-4 00:00:20".toDate()!.date
        counter.copleteThisDay(currentDate: currentDay)
        XCTAssertEqual(counter.getDayStreak(), 2, "Сразу ночью закрыл день")
        
        currentDay = "2023-07-4 23:59:59".toDate()!.date
        counter.copleteThisDay(currentDate: currentDay)
        XCTAssertEqual(counter.getDayStreak(), 2, "Тот же день, за секунду до конца дня ")
        
        currentDay = "2023-07-5 00:00:01".toDate()!.date
        counter.copleteThisDay(currentDate: currentDay)
        XCTAssertEqual(counter.getDayStreak(), 3, "через 2 секунды после последнего расклада")
        
    }

    func testIsMissedDay() throws {
        let counter = DayConterService()
        counter.deleteAllData()
        var currentDay = "2023-05-20 15:30:00".toDate()!.date
        var lastVisitDay = "2023-05-22 00:01:00".toDate()!.date
        
        lastVisitDay = "2023-05-22 00:01:00".toDate()!.date
        currentDay   = "2023-05-23 00:01:00".toDate()!.date
        var isMissed = counter.hasMissedADay(lastVisitDate: lastVisitDay, currentDate: currentDay)
        XCTAssertEqual(isMissed, false, "Не должно быть равно")
        
   
        lastVisitDay = "2023-05-22 00:01:00".toDate()!.date
        currentDay   = "2023-05-24 00:01:00".toDate()!.date
        isMissed = counter.hasMissedADay(lastVisitDate: lastVisitDay, currentDate: currentDay)
        XCTAssertEqual(isMissed, true, "Должно быть равно")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
