//
//  TabBarWireframe.swift
//  Date Dots
//
//  Created by Aaron Williamson on 1/15/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

class TabBarWireframe: NSObject {
    
    // MARK: Properties
    
    private let presenter = TabBarPresenter()
    
    private lazy var eventsNavigationWireframe = {
        EventsNavigationWireframe(parentWireframe: self)
    }()
    
    private lazy var notesNavigationWireframe = {
        NotesNavigationWireframe(parentWireframe: self)
    }()
    
    private lazy var remindersNavigationWireframe = {
        RemindersNavigationWireframe(parentWireframe: self)
    }()
    
    // MARK: Initialization
    
    override init() {
        super.init()
        presenter.wireframe = self
        presenter.view = tabBarViewController()
    }

    // MARK: Routing
    
    func presentModule(in window: UIWindow?) {
        guard let view = presenter.view else { return }
        window?.rootViewController = view
    }
    
    func presentTabs(in tabBarViewController: TabBarViewController?) {
        tabBarViewController?.setViewControllers(childViewControllers(), animated: false)
    }
    
    private func childViewControllers() -> [UIViewController] {
        let eventsView = eventsNavigationWireframe.eventsNavigationView()
        let notesView = notesNavigationWireframe.notesNavigationView()
        let remindersView = remindersNavigationWireframe.remindersNavigationView()
        
        return [eventsView, notesView, remindersView].compactMap { $0 }
    }

    // MARK: Helpers
    
    private func tabBarViewController() -> TabBarViewController {
        return TabBarViewController(presenter: presenter)
    }
}
