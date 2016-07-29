//
//  NavigationController.swift
//  MenuDrawer
//
//  Created by Olivia Lim on 7/18/16.
//  Copyright © 2016 Olivia Lim. All rights reserved.
//

import UIKit

final class NavigationController: UIViewController {
    
    struct Constants {
        static let Overhang: CGFloat = 44.0
        
        private static let VisibleDrawerWidth: CGFloat = UIScreen.mainScreen().bounds.width - Overhang
        
        //Main Content
        private static let MainContentTravelDistance = Constants.VisibleDrawerWidth
        
        //Animation
        private static let AnimationDuration: NSTimeInterval = 0.5
        private static let AnimationSpringDampening: CGFloat = 0.9
        
    }
    
    private let leftController = MenuDrawerController()
    private var leftControllerViewCenterXConstraint: NSLayoutConstraint?
    private let mainController = MainController()
    private var mainControllerViewCenterXConstraint: NSLayoutConstraint?
    
    private var deltaPanGestuerRecognizer: DeltaPanGestureRecognizer?
    private var currentPosition: Position = .Center
    
    weak var delegate: MainControllerDelegate?
    
    private enum Direction {
        case Left
        case None
    }
    
    enum Position {
        case Left
        case Center
        
        var mainDrawerCenterX: CGFloat {
            switch self {
            case .Left:
                return -Constants.MainContentTravelDistance
            case .Center:
                return 0
            }
        }
    }
    
    private var lastTranslationX: CGFloat = 0
    private var lastVelocityX: CGFloat = 0
//    private var startingTranslation = CGPoint.zero
//    private var lastDeltaVelocity = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        wire()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - API -
extension NavigationController {
    func loadController(controller: UIViewController) {
        mainController.loadController(controller)
        updatePosition(.Center)
    }
    
    func updatePosition(
        position: Position,
        animated: Bool = true,
        completion: (() -> Void)? = nil) {
        
        currentPosition = position
        updateDisplayedDrawer(currentPosition)
        mainController.updateTapViewState(currentPosition)
        
        if animated {
            UIView.animateWithDuration(
                Constants.AnimationDuration,
                delay: 0.0,
                usingSpringWithDamping: Constants.AnimationSpringDampening,
                initialSpringVelocity: 0.0,
                options: [.CurveEaseOut, .AllowUserInteraction],
                animations: {
                    self.mainControllerViewCenterXConstraint?.constant = position.mainDrawerCenterX
                    self.view.layoutIfNeeded()
            }) {
                finished in
                completion?()
            }
        }
        else {
            completion?()
            self.mainControllerViewCenterXConstraint?.constant = position.mainDrawerCenterX
        }
    }
    
}

// MARK: - View State -
extension NavigationController {
    
    
    private func calculateNextPosition(fromSwipeDirection direction: Direction) -> Position {
        
        let nextPosition: Position
        
        if direction == .None {
            return currentPosition
        } else {
            nextPosition = .Left
            return nextPosition
        }
    }
    
    private func updateDisplayedDrawer(position: Position) {
        if position == .Left {
            leftController.view.hidden = true
        }
    }
    
    private func updateDisplayedDrawer() {
        if mainControllerViewCenterXConstraint?.constant < 0 {
            leftController.view.hidden = true
        } else {
            leftController.view.hidden = true
        }
    }
}

// MARK: - DeltaPanGestureRecognizer -
extension NavigationController {
    
    func createPanGestureRecognizer(targetView: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action:(#selector(panGestureRecognized(_:))))
        targetView.addGestureRecognizer(panGesture)
    }
    
    func panGestureRecognized(sender: UIPanGestureRecognizer) {
        if sender.state == .Began {
            lastTranslationX = sender.translationInView(view).x
        }
        else if sender.state == .Changed {
            let newTranslation = sender.translationInView(view)
            let translationDelta = newTranslation.x - lastTranslationX
            lastTranslationX = newTranslation.x
            
            self.mainControllerViewCenterXConstraint?.constant += translationDelta
            
            print("new x: \(newTranslation.x),  translationDeltaX: \(translationDelta)")
        }
        else if sender.state == .Ended {
            
        }
        
        
        
        
    }

//    func deltaPanGestureRecognizer(
//        recognizer: UIPanGestureRecognizer, totalTranslation: CGPoint, lastVelocity: CGPoint) {
//        
//    }
//    
//    func deltaPanGestureRecognizer(
//        recognizer: UIPanGestureRecognizer, deltaTranslation: CGPoint, deltaVelocity: CGPoint) {
//        
//        let pastMin = mainControllerViewCenterXConstraint?.constant < Constants.MiddleDrawerMinDrag
//        let pastMax = mainControllerViewCenterXConstraint?.constant > Constants.MiddleDrawerMaxDrag
//        
//        if !pastMin && !pastMax {
//            mainControllerViewCenterXConstraint?.constant += deltaTranslation.x
//        }
//        else if pastMin {
//            mainControllerViewCenterXConstraint?.constant = Constants.MiddleDrawerMinDrag
//        }
//        else {
//            mainControllerViewCenterXConstraint?.constant = Constants.MiddleDrawerMaxDrag
//        }
//        
//        updateDisplayedDrawer()
//    }
    
}

// MARK: - Layout -
extension NavigationController {
    
    private func layout() {
        leftController.view.translatesAutoresizingMaskIntoConstraints = false
        addChildViewController(leftController)
        view.addSubview(leftController.view)
        
        mainController.view.translatesAutoresizingMaskIntoConstraints = false
        addChildViewController(mainController)
        view.addSubview(mainController.view)
        
        //leftController
        view.addConstraint(NSLayoutConstraint(
            item: leftController.view,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Width,
            multiplier: 1.0,
            constant: 0)
        )
        view.addConstraint(NSLayoutConstraint(
            item: leftController.view,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Top,
            multiplier: 1.0,
            constant: 0)
        )
        leftControllerViewCenterXConstraint = NSLayoutConstraint(
            item: leftController.view,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: view,
            attribute: .CenterX,
            multiplier: 1.0,
            constant: 0
        )
        if let constraint = leftControllerViewCenterXConstraint {
            view.addConstraint(constraint)
        }
        
        view.addConstraint(NSLayoutConstraint(
            item: leftController.view,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: 0)
        )
        
        //mainController
        view.addConstraint(NSLayoutConstraint(
            item: mainController.view,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Width,
            multiplier: 1.0,
            constant: 0)
        )
        view.addConstraint(NSLayoutConstraint(
            item: mainController.view,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Top,
            multiplier: 1.0,
            constant: 0)
        )
        mainControllerViewCenterXConstraint = NSLayoutConstraint(
            item: mainController.view,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: view,
            attribute: .CenterX,
            multiplier: 1.0,
            constant: 0
        )
        if let constraint = mainControllerViewCenterXConstraint {
            view.addConstraint(constraint)
        }
        
        view.addConstraint(NSLayoutConstraint(
            item: mainController.view,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: 0)
        )
        
    }
}

//MARK: - Wire -
extension NavigationController {
    private func wire () {
        mainController.delegate = self
        
        createPanGestureRecognizer(mainController.view)
    }
}

// MARK: - Wire -
extension NavigationController: MainControllerDelegate {
    
    func mainControllerDidPressTapView(view: MainController) {
        updatePosition(.Center)
    }
}