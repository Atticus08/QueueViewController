//
//  QueueViewController+extensions.swift
//  QueueViewController
//
//  Created by Atticus on 12/12/17.
//  Copyright © 2017 Atticus08. All rights reserved.
//

import UIKit

// MARK: - Queue View Controller Helper Method Extension

extension QueueViewController {
    /// Pop the first image view off of the queue view controller
    public func popTransition(newView: T?, propertyToChange: ViewProperty?) {
        guard let poppedView = self.viewQueue.dequeue() else { return }
        print("The size of my queue after pop: ", self.viewQueue.size)
        self.delegate?.popItem(view: poppedView.view)
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.movePoppedViewToRight(poppedView: poppedView)
        }) { (_) in
            UIView.animate(withDuration: 0.6, animations: { [weak self] in
                self?.repositionQueue(poppedView: poppedView)
            }) { (_) in
                if let newView = newView, let propertyToChange = propertyToChange {
                    // Place the popped view back on the bottom of the stack, but with
                    // the properties of the new view.
                    self.updateNewView(poppedView: poppedView, newView: newView, property: propertyToChange)
                    UIView.animate(withDuration: 0.5, animations: { [weak self] in
                        self?.placePoppedViewAtBottom(poppedView: poppedView)
                        self?.viewQueue.enqueue(poppedView)
                    })
                } else {
                    poppedView.view.removeFromSuperview()
                }
            }
        }
    }
    
    // MARK: Animation completion handler functions
    fileprivate func movePoppedViewToRight(poppedView: QueueItem) {
        let viewWidth = self.view.frame.width
        poppedView.rightConstraint?.constant += viewWidth
        poppedView.leftConstraint?.constant += viewWidth
        self.view.layoutIfNeeded()
    }
    fileprivate func repositionQueue(poppedView: QueueItem) {
        let queueSize = self.viewQueue.size
        let lineSpacing = self.queueView(minimumLineSpacingForItems: 0.0)
        for i in 0..<queueSize {
            guard let image = self.viewQueue.getNode(index: i) else { break }
            image.topConstraint?.constant -= lineSpacing + image.size.height
        }
        self.view.layoutIfNeeded()
        // Move the popped view behind the scenes, and place below the stack.
        poppedView.rightConstraint?.constant -= self.view.frame.width
        poppedView.leftConstraint?.constant -= self.view.frame.width
        poppedView.topConstraint?.constant += self.view.frame.height
    }
    fileprivate func placePoppedViewAtBottom(poppedView: QueueItem) {
        let queueSize = self.viewQueue.size
        let lineSpacing = self.queueView(minimumLineSpacingForItems: 0.0)
        poppedView.topConstraint?.constant -= self.view.frame.height - ((CGFloat(queueSize) * lineSpacing) + (CGFloat(queueSize) * poppedView.size.height))
        self.view.layoutIfNeeded()
    }
    fileprivate func updateNewView(poppedView: QueueItem, newView: T?, property: ViewProperty) {
        guard let newView = newView else { return }
        switch property {
        case .bgColor:
            poppedView.view.backgroundColor = newView.backgroundColor
        case .image:
            let newView = newView as? UIImageView
            let imageView = poppedView.view as? UIImageView
            imageView?.image = newView?.image
        case .text:
            let newView = newView as? UILabel
            let label = poppedView.view as? UILabel
            label?.text = newView?.text
        }
    }
}
