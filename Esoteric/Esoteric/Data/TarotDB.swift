let tarotDB: [Tarot] = [
    Tarot(image: "", name: "Дурак", number: 0),
    Tarot(image: "", name: "Маг", number: 1),
    Tarot(image: "", name: "Верховная жрица", number: 2),
    Tarot(image: "", name: "Императрица", number: 3),
    Tarot(image: "", name: "Император", number: 4),
    Tarot(image: "", name: "Иерофант", number: 5),
    Tarot(image: "", name: "Влюбленные", number: 6),
    Tarot(image: "", name: "Колесница", number: 7),
    Tarot(image: "", name: "Сила", number: 8),
    Tarot(image: "", name: "Отшельник", number: 9),
    Tarot(image: "", name: "Колесо Фортуны", number: 10),
    Tarot(image: "", name: "Справедливость ", number: 11),
    Tarot(image: "", name: "Повешенный", number: 12),
    Tarot(image: "", name: "Смерть", number: 13),
    Tarot(image: "", name: "Умеренность", number: 14),
    Tarot(image: "", name: "Дьявол", number: 15),
    Tarot(image: "", name: "Башня", number: 16),
    Tarot(image: "", name: "Звезда", number: 17),
    Tarot(image: "", name: "Луна", number: 18),
    Tarot(image: "", name: "Солнце", number: 19),
    Tarot(image: "", name: "Суд", number: 20),
    Tarot(image: "", name: "Мир", number: 21),
    
    
    Tarot(image: "", name: "Туз Кубков ", number: 22),
    Tarot(image: "", name: "Двойка Кубков", number: 23),
    Tarot(image: "", name: "Тройка Кубков", number: 24),
    Tarot(image: "", name: "Четверка Кубков", number: 25),
    Tarot(image: "", name: "Пятерка Кубков", number: 26),
    Tarot(image: "", name: "Шестерка Кубков", number: 27),
    Tarot(image: "", name: "Семерка Кубков", number: 28),
    Tarot(image: "", name: "Восьмерка Кубков", number: 29),
    Tarot(image: "", name: "Девятка Кубков", number: 30),
    Tarot(image: "", name: "Десятка Кубков", number: 31),
    Tarot(image: "", name: "Паж Кубков", number: 32),
    Tarot(image: "", name: "Рыцарь Кубков", number: 33),
    Tarot(image: "", name: "Королева Кубков", number: 34),
    Tarot(image: "", name: "Король Кубков", number: 35),
    
    Tarot(image: "", name: "Туз Пентаклей", number: 36),
    Tarot(image: "", name: "Двойка Пентаклей", number: 37),
    Tarot(image: "", name: "Тройка Пентаклей", number: 38),
    Tarot(image: "", name: "Четверка Пентаклей", number: 39),
    Tarot(image: "", name: "Пятерка Пентаклей", number: 40),
    Tarot(image: "", name: "Шестерка Пентаклей", number: 41),
    Tarot(image: "", name: "Семерка Пентаклей", number: 42),
    Tarot(image: "", name: "Восьмерка Пентаклей", number: 43),
    Tarot(image: "", name: "Девятка Пентаклей", number: 44),
    Tarot(image: "", name: "Десятка пентаклей", number: 45),
    Tarot(image: "", name: "Паж Пентаклей", number: 46),
    Tarot(image: "", name: "Рыцарь Пентаклей", number: 47),
    Tarot(image: "", name: "Королева Пентаклей", number: 48),
    Tarot(image: "", name: "Король пентаклей", number: 49),
    
    Tarot(image: "", name: "Туз Мечей", number: 50),
    Tarot(image: "", name: "Двойка Мечей", number: 51),
    Tarot(image: "", name: "Тройка Мечей", number: 52),
    Tarot(image: "", name: "Четверка Мечей", number: 53),
    Tarot(image: "", name: "Пятерка Мечей", number: 54),
    Tarot(image: "", name: "Шестерка Мечей", number: 55),
    Tarot(image: "", name: "Семерка Мечей", number: 56),
    Tarot(image: "", name: "Восьмерка Мечей", number: 57),
    Tarot(image: "", name: "Девятка Мечей", number: 58),
    Tarot(image: "", name: "Десятка Мечей", number: 59),
    Tarot(image: "", name: "Паж Мечей", number: 60),
    Tarot(image: "", name: "Рыцарь Мечей", number: 61),
    Tarot(image: "", name: "Королева Мечей", number: 62),
    Tarot(image: "", name: "Король Мечей ", number: 63),
    
    Tarot(image: "", name: "Туз Жезлов", number: 64),
    Tarot(image: "", name: "Двойка Жезлов", number: 65),
    Tarot(image: "", name: "Тройка жезлов", number: 66),
    Tarot(image: "", name: "Четверка жезлов", number: 67),
    Tarot(image: "", name: "Пятерка жезлов", number: 68),
    Tarot(image: "", name: "Шестерка жезлов", number: 69),
    Tarot(image: "", name: "Семерка Жезлов", number: 70),
    Tarot(image: "", name: "Восьмерка жезлов", number: 72),
    Tarot(image: "", name: "Девятка жезлов", number: 73),
    Tarot(image: "", name: "Десятка Жезлов", number: 74),
    Tarot(image: "", name: "Паж Жезлов", number: 75),
    Tarot(image: "", name: "Рыцарь Жезлов", number: 76),
    Tarot(image: "", name: "Королева Жезлов", number: 77),
    Tarot(image: "", name: "Король жезлов", number: 77)
]

import Foundation
import SwiftUI

struct Tarot: Identifiable, Hashable, Equatable {
    let id = UUID().uuidString
    let image: String
    let name: String
    let number: Int
    let description: String = ""
}

// https://dzen.ru/a/Yzg6-TxVzBVX7Q8J
