//
//  Resources.swift
//  Tracker
//
//  Created by Александр Плешаков on 04.05.2024.
//

import UIKit

enum Resources {
    
    enum Keys {
        static let onboardingWasShown = "OnboardingWasShown"
    }
    
    enum Mocks {
        static let weekdays: [Day] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        static let weekdaysStrings: [String] = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
        static let emojies: [Character] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                                        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                                        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
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
    
    enum Onboarding {
        static let firstText = "Отслеживайте только то, что хотите"
        static let secondText = "Даже если это не литры воды и йога"
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
        static let onboardingBlue = UIImage(named: "BlueImage") ?? UIImage()
        static let onboardingRed = UIImage(named: "RedImage") ?? UIImage()
        static let logo = UIImage(named: "Logo") ?? UIImage()
    }
    
    enum Colors {
        static let black = UIColor(named: "TBlack")
        static let black30 = UIColor(named: "TBlack")?.withAlphaComponent(0.3)
        static let white = UIColor(named: "TWhite")
        static let blue = UIColor(named: "TBlue")
        static let lightGray = UIColor(named: "TLightGray")
        static let searchBackgroundGray = UIColor(named: "TSearchBackgroundGray")
        static let searchTextGray = UIColor(named: "TSearchTextGray")
        static let cellBackground = UIColor(named: "TCellBackgroundGray")
        static let buttonRed = UIColor(named: "TButtonRed")
        static let white30 = UIColor(named: "TWhite30")
        static let colorsCollectionBackground = UIColor(rgb: 0xE6E8EB)
        
        enum Tracker {
            
            static let selection1 = 0xFD4C49
            static let selection2 = 0xFF881E
            static let selection3 = 0x007BFA
            static let selection4 = 0x6E44FE
            static let selection5 = 0x33CF69
            static let selection6 = 0xE66DD4
            static let selection7 = 0xF9D4D4
            static let selection8 = 0x34A7FE
            static let selection9 = 0x46E69D
            static let selection10 = 0x35347C
            static let selection11 = 0xFF674D
            static let selection12 = 0xFF99CC
            static let selection13 = 0xF6C48B
            static let selection14 = 0x7994F5
            static let selection15 = 0x832CF1
            static let selection16 = 0xAD56DA
            static let selection17 = 0x8D72E6
            static let selection18 = 0x2FD058
            
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
