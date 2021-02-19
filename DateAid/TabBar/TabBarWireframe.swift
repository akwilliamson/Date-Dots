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
    private var eventsNavigationWireframe: EventsNavigationWireframe?
    private var notesNavigationWireframe: NotesNavigationWireframe?
    private var remindersNavigationWireframe: RemindersNavigationWireframe?
    
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
    
    func presentTabs(in tabBar: TabBarViewController?) {
        eventsNavigationWireframe = EventsNavigationWireframe(parentWireframe: self)
        let eventsView = eventsNavigationWireframe?.eventsNavigationView()
        notesNavigationWireframe = NotesNavigationWireframe(parentWireframe: self)
        let notesView = notesNavigationWireframe?.notesNavigationView()
        remindersNavigationWireframe = RemindersNavigationWireframe(parentWireframe: self)
        let remindersView = remindersNavigationWireframe?.remindersNavigationView()
        
        let viewControllers = [eventsView, notesView, remindersView].compactMap { $0 }
        tabBar?.viewControllers = viewControllers
    }

    // MARK: Helpers
    
    private func tabBarViewController() -> TabBarViewController {
        return TabBarViewController(presenter: presenter)
    }
}
