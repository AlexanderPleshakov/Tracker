//
//  Resources.swift
//  Tracker
//
//  Created by Александр Плешаков on 04.05.2024.
//

import UIKit

enum Resources {
    
    enum Images {
        static let tracksTab = UIImage(named: "TabTracks") ?? UIImage()
        static let statisticTab = UIImage(named: "TabStatistic") ?? UIImage()
        static let addButton = UIImage(named: "AddButton") ?? UIImage()
        static let stubTrackersImage = UIImage(named: "StubImage") ?? UIImage()
        static let checkmark = UIImage(named: "TCheckmark") ?? UIImage()
        static let resetTextField = UIImage(named: "ResetTextField") ?? UIImage()
        static let addTrackerButton = UIImage(named: "AddTracker") ?? UIImage()
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
        }
    }
}
