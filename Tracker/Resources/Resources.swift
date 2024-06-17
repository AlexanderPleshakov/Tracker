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
        static let weekdaysStrings: [String] = [
            NSLocalizedString("monday", comment: ""),
            NSLocalizedString("tuesday", comment: ""),
            NSLocalizedString("wednesday", comment: ""),
            NSLocalizedString("thursday", comment: ""),
            NSLocalizedString("friday", comment: ""),
            NSLocalizedString("saturday", comment: ""),
            NSLocalizedString("sunday", comment: ""),
        ]
        static let shortDays: [String] = [
            NSLocalizedString("mon", comment: ""),
            NSLocalizedString("tue", comment: ""),
            NSLocalizedString("wed", comment: ""),
            NSLocalizedString("thu", comment: ""),
            NSLocalizedString("fri", comment: ""),
            NSLocalizedString("sat", comment: ""),
            NSLocalizedString("sun", comment: ""),
        ]
        static let emojies: [Character] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                                        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                                        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
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
        
        static let alwaysWhite = UIColor(rgb: 0xFFFFFF)
        static let alwaysBlack = UIColor(rgb: 0x1A1B22)
        static let black30 = UIColor(rgb: 0x1A1B22, a: 0.3)
        static let secondaryGray = UIColor(rgb: 0xAEAFB4)
        static let blue = UIColor(rgb: 0x3772E7)
        static let red = UIColor(rgb: 0xF56B6C)
        static let emojiCollectionBackground = UIColor(rgb: 0xE6E8EB)
        static let whiteAlpha = UIColor(rgb: 0xFFFFFF, a: 0.3)
        
        static let background = UIColor.color(light: UIColor(rgb: 0xFFFFFF),
                                              dark: UIColor(rgb: 0x1A1B22))
        
        static let foreground = UIColor.color(light: UIColor(rgb: 0x1A1B22),
                                             dark: UIColor(rgb: 0xFFFFFF))
        
        static let cellBackground = UIColor.color(light: UIColor(rgb: 0xE6E8EB, a: 0.30),
                                                  dark: UIColor(rgb: 0x414141, a: 0.85))
        static let searchBackgroundGray = UIColor.color(light: UIColor(rgb: 0x767680, a: 0.12),
                                                        dark: UIColor(rgb: 0x767680, a: 0.24))
        static let searchText = UIColor.color(light: UIColor(rgb: 0xAEAFB4),
                                                  dark: UIColor(rgb: 0xEBEBF5))
        static let datePicker = UIColor(rgb: 0xF0F0F0)
        
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
