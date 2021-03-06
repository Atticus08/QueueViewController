//
//  QueueViewController.swift
//  GetFritzed
//
//  Created by Tom Fritz on 12/11/17.
//  Copyright © 2017 Tom Fritz. All rights reserved.
//

import UIKit

/// Delegate protocol for Queue View Controller
public protocol QueueViewControllerDelegate: class {
    /// Informs the delegate that the queue has been loaded successfully
    func queueLoaded()
    
    /**
     Lets the delegate know that a view has been dequeued, and allows the delegate to
     access that view.
    - Parameter view: The view that was dequeued from the queue
     */
    func popItem(view: UIView)
}
open class QueueViewController<T: UIView>: UIViewController {
    
    // MARK: Open/Public Class Properties
    
    // The datasource for the Queue View Controller
    open var datasourceItem: Any?
    
    // TODO: NEED TO STILL BUILD IN DIRECTION OF QUEUE
    public enum QueueDirection { case vertical, horizontal }
    public var layoutDirection: QueueDirection = .vertical
    
    // Allows user to select which property of the queue item to modify
    // THIS IS TEMPORARY
    public enum ViewProperty {
        case image, bgColor, text
    }
    
    // Adjusts the animation duration during the initial load of the queue.
    public var queueLoadAnimateTimeConstant: TimeInterval = 0.65
    
    // Delegate property for controller
    public weak var delegate: QueueViewControllerDelegate?
    
    // MARK: Internal Class Properties
    
    // This internal structure allows the controller to know which views need to
    // be moved or dequeued. It also simplifies the process for animating auto layout constraints.
    internal struct QueueItem {
        var view: T = T()
        var size: CGSize = .zero
        var topConstraint: NSLayoutConstraint?
        var leftConstraint: NSLayoutConstraint?
        var bottomConstraint: NSLayoutConstraint?
        var rightConstraint: NSLayoutConstraint?
        var heightConstraint: NSLayoutConstraint?
        var widthConstraint: NSLayoutConstraint?
    }
    internal var viewQueue = Queue<QueueItem>()
    
    // MARK: Open/Public Class Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // When the view appears, enqueue the first set of views, and inform the
    // delegate when the queue has finished loading.
    open override func viewDidAppear(_ animated: Bool) {
        self.queueView(setUpWithViews: self.queueSources())
        let numberOfItemsToShow = self.numberOfItemsToShow()
        for index in 0..<numberOfItemsToShow {
            let newItem = self.viewQueue.getNode(index: index)
            self.enqueueTransition(newItem: newItem!, index: index)
        }
        self.delegate?.queueLoaded()
    }
    
    /**
     Override method to return the number of items to be displayed on the view contoller's view.
     - Returns: The number of items to be displayed within the view
     */
    open func numberOfItemsToShow() -> Int {
        return 1
    }
    /**
     Override method to set the size for each item the specified index.
     - Parameter index: The index of the item
     - Returns: The size of the item
     */
    open func queueView(sizeForItemAt index: Int) -> CGSize {
        return .zero
    }
    /**
     Override method to set the line spacing between each item.
     - Parameter lineSpacing: The line spacing between each item
     - Returns: The line spacing specified by user
     */
    open func queueView(minimumLineSpacingForItems lineSpacing: CGFloat) -> CGFloat {
        return 0.0
    }
    /**
     Override method to set the spacing between the edges of the view and each item.
     - Parameter edgeSpacing: The spacing between the edges of the view and the item.
     - Returns: The edge spacing specified by the user.
     */
    open func queueView(minimumEdgeSpacingForItems edgeSpacing: CGFloat) -> CGFloat {
        return 0.0
    }
    
    /**
     Override the method to set the image views to be placed in the view controller.
     - Returns: The image views to be placed inside the queue controller's view
     */
    open func queueSources() -> [T] {
        return []
    }
}

// MARK: - Queue View Controller Setup Methods Extension

extension QueueViewController {
    /**
     Set up image view queue within view controller.
     - Parameter views: The image views to be loaded within queue view controller
     */
    private func queueView(setUpWithViews views: [T]) {
        let numberOfItemsToShow = self.numberOfItemsToShow()
        for index in 0..<numberOfItemsToShow {
            let queueView = self.setupItem(atIndex: index, view: views[index])
            self.viewQueue.enqueue(queueView)
        }
    }
    
    /**
     Sets up an image view on the view, and returns the image view queue item to be placed in the controller's
     queue.
     - Parameters:
        - index: The queues index at which the image view will be placed.
        - imageView: The image view to be displayed on the view
     - Returns: Item to store in controllers queue
     */
    private func setupItem(atIndex index: Int, view: T) -> QueueItem {
        var queueItem = QueueItem()
        self.view.addSubview(view)
        
        queueItem.view = view
        queueItem.size = self.queueView(sizeForItemAt: index)
        let minimumEdgeSpacing = self.queueView(minimumEdgeSpacingForItems: 0.0)
        let minimumLineSpacing = self.queueView(minimumLineSpacingForItems: 0.0)

        // Calculates the offset from the views topAnchor that each image will be placed at.
        // We need to do this to animate the objects that have layout constraints.
        view.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintOffset = minimumLineSpacing + (minimumLineSpacing + queueItem.size.height) * CGFloat(index)
        
        // Place views below the queue, off the screen. When the screen first appears, we animate the views being added to the queue.
        queueItem.topConstraint = view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: self.view.frame.height + topConstraintOffset)
        queueItem.leftConstraint = view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: minimumEdgeSpacing)
        queueItem.rightConstraint = view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -minimumEdgeSpacing)
        queueItem.heightConstraint = view.heightAnchor.constraint(equalToConstant: queueItem.size.height)
        queueItem.topConstraint?.isActive = true
        queueItem.leftConstraint?.isActive = true
        queueItem.rightConstraint?.isActive = true
        queueItem.heightConstraint?.isActive = true
        queueItem.widthConstraint?.isActive = true
        self.view.layoutIfNeeded()
        return queueItem
    }
    
    /**
     Animates a "slide-in" motion for the views when the queue loaded on the screen.
     - Parameters:
        - newItem: The new item to be placed into the queue
        - index: The location of the new item in the queue
     */
    private func enqueueTransition(newItem: QueueItem, index: Int) {
        newItem.topConstraint?.constant -= self.view.frame.height
        UIView.animate(withDuration: (self.queueLoadAnimateTimeConstant * TimeInterval(index)*0.5) + self.queueLoadAnimateTimeConstant, delay: 0.0, animations: {
            self.view.layoutIfNeeded()
        })
    }
}
