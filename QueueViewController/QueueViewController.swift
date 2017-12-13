//
//  QueueViewController.swift
//  GetFritzed
//
//  Created by Tom Fritz on 12/11/17.
//  Copyright © 2017 Tom Fritz. All rights reserved.
//

import UIKit

public protocol QueueViewControllerDelegate: class {
    func popItem(item: UIImageView)
}
open class QueueViewController<T>: UIViewController {
    public enum QueueDirection { case vertical, horizontal }
    public var layoutDirection: QueueDirection = .vertical
    public weak var delegate: QueueViewControllerDelegate?
    
    internal struct QueueImageViewItem {
        var imageView: UIImageView = UIImageView()
        var size: CGSize = .zero
        var topConstraint: NSLayoutConstraint?
        var leftConstraint: NSLayoutConstraint?
        var bottomConstraint: NSLayoutConstraint?
        var rightConstraint: NSLayoutConstraint?
        var heightConstraint: NSLayoutConstraint?
        var widthConstraint: NSLayoutConstraint?
    }
    internal var imageViewQueue = Queue<QueueImageViewItem>()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.queueView(setUpWithImageViews: self.queueSources())
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
    open func queueSources() -> [UIImageView] {
        return []
    }
}

// MARK: - Queue View Controller Setup Methods Extension

extension QueueViewController {
    /**
     Set up image view queue within view controller.
     - Parameter imageViews: The image views to be loaded within queue view controller
     */
    private func queueView(setUpWithImageViews imageViews: [UIImageView]) {
        let numberOfItemsToShow = self.numberOfItemsToShow()
        for index in 0..<numberOfItemsToShow {
            let queueView = self.setupItem(atIndex: index, imageView: imageViews[index])
            self.imageViewQueue.enqueue(queueView)
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
    private func setupItem(atIndex index: Int, imageView: UIImageView) -> QueueImageViewItem {
        var queueItem = QueueImageViewItem()
        self.view.addSubview(imageView)
        
        queueItem.imageView = imageView
        queueItem.size = self.queueView(sizeForItemAt: index)
        let minimumEdgeSpacing = self.queueView(minimumEdgeSpacingForItems: 0.0)
        let minimumLineSpacing = self.queueView(minimumLineSpacingForItems: 0.0)

        // Calculates the offset from the views topAnchor that each image will be placed at.
        // We need to do this to animate the objects that have layout constraints.
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintOffset = minimumLineSpacing + (minimumLineSpacing + queueItem.size.height) * CGFloat(index)
        queueItem.topConstraint = imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: topConstraintOffset)
        queueItem.leftConstraint = imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: minimumEdgeSpacing)
        queueItem.rightConstraint = imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -minimumEdgeSpacing)
        queueItem.heightConstraint = imageView.heightAnchor.constraint(equalToConstant: queueItem.size.height)

        queueItem.topConstraint?.isActive = true
        queueItem.leftConstraint?.isActive = true
        queueItem.rightConstraint?.isActive = true
        queueItem.heightConstraint?.isActive = true
        queueItem.widthConstraint?.isActive = true
        return queueItem
    }
}
