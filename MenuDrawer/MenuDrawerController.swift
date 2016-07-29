//
//  MenuDrawerController.swift
//  MenuDrawer
//
//  Created by Olivia Lim on 7/18/16.
//  Copyright © 2016 Olivia Lim. All rights reserved.
//

import UIKit

// MARK: Init and Lifecycle -
final class MenuDrawerController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        wire()
    }
}

// MARK: - Layout -
extension MenuDrawerController {
    
    private func layout() {
        view.backgroundColor = .redColor()
    }
}

//MARK: - Wire-
extension MenuDrawerController {
    private func wire() {
        
    }
}
