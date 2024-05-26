//
//  Resources.swift
//  Tracker
//
//  Created by Александр Плешаков on 04.05.2024.
//

import UIKit

enum Resources {
    
    enum Mocks {
        static let weekdays: [Day] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        static let weekdaysStrings: [String] = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
        static let trackers = [
            TrackerCategory(title: "Важное", trackers: [
                Tracker(id: UUID(), name: "Поливать растения", color: Resources.Colors.Tracker.trackersColors[Int.random(in: 0..<18)], emoji: "❤️", timetable: [.monday, .wednesday], creationDate: Date()),
                Tracker(id: UUID(), name: "Кошка заслонила камеру на созвоне", color: Resources.Colors.Tracker.trackersColors[Int.random(in: 0..<18)], emoji: "👻", timetable: [.tuesday], creationDate: Date()),
                Tracker(id: UUID(), name: "Бабушка прислала открытку в вотсапе", color: Resources.Colors.Tracker.trackersColors[Int.random(in: 0..<18)], emoji: "☺️", timetable: [.wednesday], creationDate: Date())]),
            TrackerCategory(title: "Радостные мелочи", trackers: [
                Tracker(id: UUID(), name: "Свидания в апреле", color: Resources.Colors.Tracker.trackersColors[Int.random(in: 0..<18)], emoji: "😂", timetable: [.thursday, .tuesday], creationDate: Date()),
                Tracker(id: UUID(), name: "Хорошее настроение", color: Resources.Colors.Tracker.trackersColors[Int.random(in: 0..<18)], emoji: "💕", timetable: [.friday, .wednesday], creationDate: Date()),
                Tracker(id: UUID(), name: "Легкая тревожность", color: Resources.Colors.Tracker.trackersColors[Int.random(in: 0..<18)], emoji: "🙃", timetable: [.sunday], creationDate: Date())])
        ]
    }
    
    enum Titles {
        static let trackersTitle = "Трекеры"
        static let statisticTitle = "Статистика"
        static let newTrackerTitle = "Создание трекера"
        static let habitTitle = "Новая привычка"
        static let eventTitle = "Новое нерегулярное событие"
        static let timetableTitle = "Расписание"
        static let categoriesTitle = "Категория"
        static let newCategoryTitle = "Новая категория"
        
    }
    
    enum Images {
        static let tracksTab = UIImage(named: "TabTracks") ?? UIImage()
        static let statisticTab = UIImage(named: "TabStatistic") ?? UIImage()
        static let addButton = UIImage(named: "AddButton") ?? UIImage()
        static let stubTrackersImage = UIImage(named: "StubImage") ?? UIImage()
        static let checkmark = UIImage(named: "TCheckmark") ?? UIImage()
        static let resetTextField = UIImage(named: "ResetTextField") ?? UIImage()
        static let completeTrackerButton = UIImage(named: "AddTracker") ?? UIImage()
        static let doneTracker = UIImage(named: "DoneTracker") ?? UIImage()
    }
    
    enum Colors {
        static let black = UIColor(named: "TBlack")
        static let white = UIColor(named: "TWhite")
        static let blue = UIColor(named: "TBlue")
        static let lightGray = UIColor(named: "TLightGray")
        static let searchBackgroundGray = UIColor(named: "TSearchBackgroundGray")
        static let searchTextGray = UIColor(named: "TSearchTextGray")
        static let cellBackground = UIColor(named: "TCellBackgroundGray")
        static let buttonRed = UIColor(named: "TButtonRed")
        static let white30 = UIColor(named: "TWhite30")
        
        enum Tracker {
            static let selection1 = UIColor(rgb: 0xFD4C49)
            static let selection2 = UIColor(rgb: 0xFF881E)
            static let selection3 = UIColor(rgb: 0x007BFA)
            static let selection4 = UIColor(rgb: 0x6E44FE)
            static let selection5 = UIColor(rgb: 0x33CF69)
            static let selection6 = UIColor(rgb: 0xE66DD4)
            static let selection7 = UIColor(rgb: 0xF9D4D4)
            static let selection8 = UIColor(rgb: 0x34A7FE)
            static let selection9 = UIColor(rgb: 0x46E69D)
            static let selection10 = UIColor(rgb: 0x35347C)
            static let selection11 = UIColor(rgb: 0xFF674D)
            static let selection12 = UIColor(rgb: 0xFF99CC)
            static let selection13 = UIColor(rgb: 0xF6C48B)
            static let selection14 = UIColor(rgb: 0x7994F5)
            static let selection15 = UIColor(rgb: 0x832CF1)
            static let selection16 = UIColor(rgb: 0xAD56DA)
            static let selection17 = UIColor(rgb: 0x8D72E6)
            static let selection18 = UIColor(rgb: 0x2FD058)
            
            static let trackersColors = [
                Resources.Colors.Tracker.selection1, Resources.Colors.Tracker.selection2,
                Resources.Colors.Tracker.selection3, Resources.Colors.Tracker.selection4,
                Resources.Colors.Tracker.selection5, Resources.Colors.Tracker.selection6,
                Resources.Colors.Tracker.selection7, Resources.Colors.Tracker.selection8,
                Resources.Colors.Tracker.selection9, Resources.Colors.Tracker.selection10,
                Resources.Colors.Tracker.selection11, Resources.Colors.Tracker.selection12,
                Resources.Colors.Tracker.selection13, Resources.Colors.Tracker.selection14,
                Resources.Colors.Tracker.selection15, Resources.Colors.Tracker.selection16,
                Resources.Colors.Tracker.selection17, Resources.Colors.Tracker.selection18,
            
            ]
        }
    }
}
