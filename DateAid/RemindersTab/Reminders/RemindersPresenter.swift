//
//  RemindersPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/9/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol RemindersEventHandling: class {
    
    func viewLoaded()
}

protocol RemindersInteractorOutputting: class {}

class RemindersPresenter {

    // MARK: VIPER
    
    public var view: RemindersViewOutputting?
    public var interactor: RemindersInteractorInputting?
    public weak var wireframe: RemindersWireframe?
    
    // MARK: Constants
    
    // MARK: Constants

    private enum Constant {
        enum String {
            static let title = "Reminders"
        }
        enum Image {
            static let iconSelected = UIImage(named: "selected-reminder")!.withRenderingMode(.alwaysTemplate)
            static let iconUnselected =  UIImage(named: "unselected-reminder")!.withRenderingMode(.alwaysTemplate)
        }
    }
}

extension RemindersPresenter: RemindersEventHandling {
    
    func viewLoaded() {
        view?.configureTabBar(image: Constant.Image.iconUnselected, selectedImage: Constant.Image.iconSelected)
    }
}
    
extension RemindersPresenter: RemindersInteractorOutputting {}
