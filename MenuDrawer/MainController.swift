//
//  MainController.swift
//  MenuDrawer
//
//  Created by Olivia Lim on 7/18/16.
//  Copyright © 2016 Olivia Lim. All rights reserved.
//

import UIKit

protocol MainControllerDelegate: class {
    func mainControllerDidPressTapView(view: MainController)
}

final class MainController: UIViewController {
    private var loadedController: UIViewController?

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.blueColor()
        return view
    }()
    
    private let leftTapView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.yellowColor()
        return view
    }()
    
    func loadMainContent(controller: UIViewController) {
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        guard let rootViewController = appDelegate?.window?.rootViewController as? NavigationController else {
            return
        }
        
        rootViewController.loadController(controller)
    }
    
    func loadController(controller: UIViewController) {
        unloadContentController()
        
        loadMainContent(controller)
        
        loadedController = controller
        layoutContentController()
        view.layoutIfNeeded()
    }
    
    private func unloadContentController() {
        loadedController?.view.removeFromSuperview()
        loadedController?.removeFromParentViewController()
        loadedController = nil
    }
    
    func updateTapViewState(position: NavigationController.Position) {
        if position == .Center {
            leftTapView.userInteractionEnabled = false
        }
        else {
            leftTapView.userInteractionEnabled = true
        }
    }
    
    weak var delegate: MainControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
}

//MARK: - Layout -
extension MainController {
    
    private func layoutContentController() {
        
        guard let loadedController = loadedController else {
            return
        }
        
        addChildViewController(loadedController)
        loadedController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loadedController.view)
    }
    
    private func layout() {
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowRadius = UIScreen.mainScreen().bounds.width * 0.08
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        view.backgroundColor = .whiteColor()
        
        view.addSubview(contentView)
        
        view.addSubview(leftTapView)
        
        view.addConstraint(NSLayoutConstraint(
            item: contentView,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Width,
            multiplier: 1.0,
            constant: 0)
        )
        view.addConstraint(NSLayoutConstraint(
            item: contentView,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Height,
            multiplier: 1.0,
            constant: 0)
        )
        view.addConstraint(NSLayoutConstraint(
            item: contentView,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: view,
            attribute: .CenterX,
            multiplier: 1.0,
            constant: 0)
        )
        view.addConstraint(NSLayoutConstraint(
            item: contentView,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: view,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: 0)
        )
        
        //leftTapView
        view.addConstraint(NSLayoutConstraint(
            item: leftTapView,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .Width,
            multiplier: 1.0,
            constant: NavigationController.Constants.Overhang)
        )
        view.addConstraint(NSLayoutConstraint(
            item: leftTapView,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Left,
            multiplier: 1.0,
            constant: 0)
        )
        view.addConstraint(NSLayoutConstraint(
            item: leftTapView,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Top,
            multiplier: 1.0,
            constant: 0)
        )
        view.addConstraint(NSLayoutConstraint(
            item: leftTapView,
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
extension MainController {
    
    private func wire() {
        let leftTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(leftTapViewPressed(_:)))
        leftTapView.addGestureRecognizer(leftTapRecognizer)
    }
    
    func leftTapViewPressed(sender: UITapGestureRecognizer) {
        delegate?.mainControllerDidPressTapView(self)
    }
}







