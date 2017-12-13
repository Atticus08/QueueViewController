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
    public func popTransition(newImageView: UIImageView?) {
        guard let poppedView = self.imageViewQueue.dequeue() else { return }
        print("The size of my queue after pop: ", self.imageViewQueue.size)
        self.delegate?.popItem(item: poppedView.imageView)
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.movePoppedViewToRight(poppedView: poppedView)
        }) { (_) in
            UIView.animate(withDuration: 0.75, animations: { [weak self] in
                self?.repositionQueue(poppedView: poppedView, newImageView: newImageView)
            }) { (_) in
                if let _ = newImageView {
                    UIView.animate(withDuration: 0.4, animations: { [weak self] in
                        self?.placePoppedViewAtBottom(poppedView: poppedView)
                    })
                } else {
                    poppedView.imageView.removeFromSuperview()
                }
            }
        }
    }
    
    // MARK: Animation completion handler functions
    fileprivate func movePoppedViewToRight(poppedView: QueueImageViewItem) {
        let viewWidth = self.view.frame.width
        poppedView.rightConstraint?.constant += viewWidth
        poppedView.leftConstraint?.constant += viewWidth
        self.view.layoutIfNeeded()
    }
    fileprivate func repositionQueue(poppedView: QueueImageViewItem, newImageView: UIImageView?) {
        let queueSize = self.imageViewQueue.size
        let lineSpacing = self.queueView(minimumLineSpacingForItems: 0.0)
        for i in 0..<queueSize {
            guard let image = self.imageViewQueue.getNode(index: i) else { break }
            image.topConstraint?.constant -= lineSpacing + image.size.height
        }
        poppedView.topConstraint?.constant += (CGFloat(queueSize) * lineSpacing) + (CGFloat(queueSize) * poppedView.size.height)
        if let newColor = newImageView?.backgroundColor {
            poppedView.imageView.backgroundColor = newColor
            self.imageViewQueue.enqueue(poppedView)
        }
        self.view.layoutIfNeeded()
        
    }
    fileprivate func placePoppedViewAtBottom(poppedView: QueueImageViewItem) {
        let viewWidth = self.view.frame.width
        poppedView.rightConstraint?.constant -= viewWidth
        poppedView.leftConstraint?.constant -= viewWidth
        self.view.layoutIfNeeded()
    }
}
