//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Александр Плешаков on 17.06.2024.
//

import SnapshotTesting
import XCTest
@testable import Tracker

final class TrackerTests: XCTestCase {
    
    // MARK: Light Theme
    
    // MARK: Main screen tests

    func testTrackersScreenLight() throws {
        let vc = TrackersViewController()
        
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .light))])
    }
    
    func testTrackersNavBarLight() throws {
        let vc = TrackersViewController()
        let nc = TrackersNavigationController(rootViewController: vc)
        
        assertSnapshots(of: nc, as: [.image(traits: .init(userInterfaceStyle: .light))])
    }
    
    func testTabBarLight() throws {
        let tb = TabBarViewController()
        
        assertSnapshots(of: tb, as: [.image(traits: .init(userInterfaceStyle: .light))])
    }
    
    func testTrackersCollectionNoCompletedCellLight() throws {
        let cell = TrackersCollectionViewCell(frame: CGRect(x: 0, y: 0, width: 167, height: 132))
        let tracker = Tracker(id: UUID(), name: "Test", color: 0x46E69D, emoji: "👽", timetable: [.monday], creationDate: Date())
        cell.configure(tracker: tracker, isCompleted: false, completedDays: 3, date: Date(), isPinned: false)
        
        assertSnapshots(of: cell, as: [.image(traits: .init(userInterfaceStyle: .light))])
    }
    
    func testTrackersCollectionCompletedCellLight() throws {
        let cell = TrackersCollectionViewCell(frame: CGRect(x: 0, y: 0, width: 167, height: 132))
        let tracker = Tracker(id: UUID(), name: "Test", color: 0x46E69D, emoji: "👽", timetable: [.monday], creationDate: Date())
        cell.configure(tracker: tracker, isCompleted: true, completedDays: 3, date: Date(), isPinned: false)
        
        assertSnapshots(of: cell, as: [.image(traits: .init(userInterfaceStyle: .light))])
    }
    
    // MARK: Tracker creation tests
    
    func testNewTrackerScreenLight() throws {
        let vc = NewTrackerViewController(currentDate: Date())
        
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .light))])
    }
    
    func testNewHabitScreenLight() throws {
        let viewModel = NewTrackerViewModel(type: .habit, date: Date())
        let vc = HabitOrEventViewController(viewModel: viewModel)
        
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .light))])
    }
    
    func testNewEventScreenLight() throws {
        let viewModel = NewTrackerViewModel(type: .event, date: Date())
        let vc = HabitOrEventViewController(viewModel: viewModel)
        
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .light))])
    }
    
    func testTimetableScreenLight() throws {
        let vc = TimetableViewController(viewModel: TimetableViewModel())
        
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .light))])
    }
    
    func testCategoriesScreenLight() throws {
        let vc = CategoriesViewController(viewModel: CategoriesViewModelMock())
        
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .light))])
    }
    
    func testNewCategoryScreenLight() throws {
        
        let vc = NewCategoryViewController(viewModel: CategoriesViewModelMock())
        
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .light))])
    }
    
    // MARK: Dark Theme
    
    func testTrackersScreenDark() throws {
        let vc = TrackersViewController()
        
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }
    
    func testTrackersNavBarDark() throws {
        let vc = TrackersViewController()
        let nc = TrackersNavigationController(rootViewController: vc)
        
        assertSnapshots(of: nc, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }
    
    func testTabBarDark() throws {
        let tb = TabBarViewController()
        
        assertSnapshots(of: tb, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }
    
    func testTrackersCollectionNoCompletedCellDark() throws {
        let cell = TrackersCollectionViewCell(frame: CGRect(x: 0, y: 0, width: 167, height: 132))
        let tracker = Tracker(id: UUID(), name: "Test", color: 0x46E69D, emoji: "👽", timetable: [.monday], creationDate: Date())
        cell.configure(tracker: tracker, isCompleted: false, completedDays: 3, date: Date(), isPinned: false)
        
        assertSnapshots(of: cell, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }
    
    func testTrackersCollectionCompletedCellDark() throws {
        let cell = TrackersCollectionViewCell(frame: CGRect(x: 0, y: 0, width: 167, height: 132))
        let tracker = Tracker(id: UUID(), name: "Test", color: 0x46E69D, emoji: "👽", timetable: [.monday], creationDate: Date())
        cell.configure(tracker: tracker, isCompleted: true, completedDays: 3, date: Date(), isPinned: false)
        
        assertSnapshots(of: cell, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }
    
    // MARK: Tracker creation tests
    
    func testNewTrackerScreenDark() throws {
        let vc = NewTrackerViewController(currentDate: Date())
        
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }
    
    func testNewHabitScreenDark() throws {
        let viewModel = NewTrackerViewModel(type: .habit, date: Date())
        let vc = HabitOrEventViewController(viewModel: viewModel)
        
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }
    
    func testNewEventScreenDark() throws {
        let viewModel = NewTrackerViewModel(type: .event, date: Date())
        let vc = HabitOrEventViewController(viewModel: viewModel)
        
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }
    
    func testTimetableScreenDark() throws {
        let vc = TimetableViewController(viewModel: TimetableViewModel())
        
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }
    
    func testCategoriesScreenDark() throws {
        let vc = CategoriesViewController(viewModel: CategoriesViewModelMock())
        
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }
    
    func testNewCategoryScreenDark() throws {
        
        let vc = NewCategoryViewController(viewModel: CategoriesViewModelMock())
        
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }
}
