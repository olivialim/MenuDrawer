//
//  DeltaPanGestureRecognizerDelegate.swift
//  MenuDrawer
//
//  Created by Olivia Lim on 7/20/16.
//  Copyright © 2016 Olivia Lim. All rights reserved.
//

import UIKit

protocol DeltaPanGestureRecognizerDelegate: class {
    func deltaPanGestureRecognizer(
        recognizer: UIPanGestureRecognizer, totalTranslation: CGPoint, lastVelocity: CGPoint)
    
    func deltaPanGestureRecognizer(
        recognizer: UIPanGestureRecognizer, deltaTranslation: CGPoint, deltaVelocity: CGPoint)
}

//Incapsulate the functionality for getting a pan delta
class DeltaPanGestureRecognizer: NSObject, UIGestureRecognizerDelegate {
    
    private var lastTranslation = CGPoint.zero
    private var lastVelocity = CGPoint.zero
    private var startingTranslation = CGPoint.zero
    private var lastDeltaVelocity = CGPoint.zero
    
    var containerView: UIView
    weak var delegate: DeltaPanGestureRecognizerDelegate?
    
    init(containerView: UIView) {
        self.containerView = containerView
        super.init()
        
        let panGestureRecognizer = UIPanGestureRecognizer(
            target: self, action: #selector(panGestureRecognized(_:)))
        
        panGestureRecognizer.delegate = self
        containerView.addGestureRecognizer(panGestureRecognizer)
    }
    
    //MARK: - UIGestureRecognizerDelegate
    func panGestureRecognized(sender: UIPanGestureRecognizer) {
        if sender.state == .Began {
            startingTranslation = sender.translationInView(containerView)
            lastTranslation = CGPoint.zero
        }
        else if sender.state == .Changed {
            let newTranslation = sender.translationInView(containerView)
            let newVelocity = sender.velocityInView(containerView)
            
            let translationDelta = CGPoint(
                x: newTranslation.x - lastTranslation.x,
                y: newTranslation.y - lastTranslation.y)
            lastTranslation = newTranslation
            
            let velocityDelta = CGPoint(
                x: newVelocity.x - lastVelocity.x,
                y: newVelocity.y - lastVelocity.y)
            lastVelocity = newVelocity
            lastDeltaVelocity = velocityDelta
            
            delegate?.deltaPanGestureRecognizer(
                sender,deltaTranslation: translationDelta, deltaVelocity: velocityDelta)
        }
        else if sender.state == .Ended {
            let currentTranslation = sender.translationInView(containerView)
            let directionX: CGFloat = currentTranslation.x < startingTranslation.x ? -1 : 1
            let directionY: CGFloat = currentTranslation.y < startingTranslation.y ? -1 : 1
            
            let totalTranslationDelta = CGPoint(
                x: abs(startingTranslation.x - currentTranslation.x) * directionX,
                y: abs(startingTranslation.y - currentTranslation.y) * directionY)
            
            delegate?.deltaPanGestureRecognizer(sender,
                                                totalTranslation:totalTranslationDelta, lastVelocity: lastVelocity)
        }
    }
}

















