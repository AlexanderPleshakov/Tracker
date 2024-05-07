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
    }
    
    enum Colors {
        static let black = UIColor(named: "TBlack")
        static let white = UIColor(named: "TWhite")
        static let blue = UIColor(named: "TBlue")
        static let lightGray = UIColor(named: "TLightGray")
        static let searchBackgroundGray = UIColor(named: "TSearchBackgroundGray")
        static let searchTextGray = UIColor(named: "TSearchTextGray")
    }
}
