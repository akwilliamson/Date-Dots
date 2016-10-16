//
//  InitialImportPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/15/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit

struct InitialImportPresenter {

    var activityIndicator: UIActivityIndicatorView {
    
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.transform = CGAffineTransform(scaleX: 2, y: 2)
        activityIndicator.isHidden = true
        
        return activityView
    }

}
