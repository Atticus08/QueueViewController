//
//  Queue.swift
//  GetFritzed
//
//  Created by Tom Fritz on 12/11/17.
//  Copyright © 2017 Tom Fritz. All rights reserved.
//

/// Data Structure with FIFO order
public struct Queue<T> {
    private var list: LinkedList<T> = LinkedList<T>()
    public var size: Int {
        get { return list.size }
    }
    public var isEmpty: Bool {
        get { return list.isEmpty }
    }
    public var first: T? {
        get { return list.first?.data }
    }
    public var last: T? {
        get { return list.last?.data}
    }
    
    /**
     Append a new object to the end of the queue.
        - Parameter object: Object being added to queue
     */
    public mutating func enqueue(_ element: T) {
        list.append(element)
    }
    
    /**
     Remove object from front of the queue.
    - Returns: Returns the object's data after removal
     */
    public mutating func dequeue() -> T?{
        guard !list.isEmpty, let element = list.first else {
            return nil
        }
        return list.remove(element)
    }
    
    public func getNode(index: Int) -> T? {
        guard !list.isEmpty else { return nil }
        return list.findNode(index: index)
    }
}
