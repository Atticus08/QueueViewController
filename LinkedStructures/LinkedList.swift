//
//  LinkedList.swift
//  GetFritzed
//
//  Created by Tom Fritz on 12/11/17.
//  Copyright © 2017 Tom Fritz. All rights reserved.
//

/**
 Node to be used in linked list.
 */
public final class LinkedNode<T> {
    var data: T
    var next: LinkedNode<T>?
    weak var previous: LinkedNode<T>?
    init(data: T) {
        self.data = data
    }
}

public struct LinkedList<T> {
    public typealias Node = LinkedNode<T>
    
    private var head: Node?
    private var tail: Node?
    public private(set) var size: Int = 0
    public var first: Node? {
        get { return head }
    }
    public var last: Node? {
        get { return tail }
    }
    public var isEmpty: Bool {
        get { return self.size == 0 }
    }
    
    public init () { }

    /**
     Append new node to the end of the list
     - parameters:
        - data: Data to be stored in new node.
     */
    public mutating func append(_ data: T) {
        let tmpNode: Node = Node(data: data)
        // Verify tail isn't null, if it is, then that means we're at the beginning of the list.
        if let tail = self.tail {
            tmpNode.previous = tail
            tail.next = tmpNode
        } else {
            self.head = tmpNode
        }
        self.tail = tmpNode
        self.size += 1
    }
    
    /**
     Remove node from specified position in list.
     - returns:
     The Node that was removed.
     - parameters:
     - position: The position of the node to remove in the list.
     */
    public mutating func remove(_ node: Node) -> T? {
        let prev = node.previous
        let next = node.next
        
        // Check the previous link, and link it to the next of the node being removed.
        if let prev = prev {
            prev.next = next
        }
        // If previous is null, then we know we're at the head. Reset the head address to the next node.
        else {
            self.head = next
        }
        
        // Set next node's previous link to point at the node behind the one being removed.
        next?.previous = prev
        
        // Reset tail if we're pulling from the end of the linked list
        if next == nil {
            tail = prev
        }
        
        // Kill the requested node
        node.previous = nil
        node.next = nil
        self.size -= 1
        return node.data
    }
    
    /**
     Traverse through the linked list to locate the desired node from the specified
     index.
     - Parameter index: The location of the node we want to find in the list.
     - Returns: The discovered node, or nil if the node was not found.
     */
    public func findNode(index: Int) -> T? {
        guard let head = self.head else { return nil}
        var node: Node
        // Return the head of the list if we want the first element
        if index == 0 {
            node = head
        }
        // Not worried about error checking right now. If we ask for a size greater than the
        // size of the list, then we just return the tail.
        else if let tail = self.tail, index >= self.size - 1 {
            node = tail
        }
        // Traverse through the list until we find the node we want.
        // I do NULL checking, which I don't need to do since we have a size count
        // and have already verified if the requested index was greater than the size
        // of the list. However, I'll leave it in to be safe for now.
        else {
            var currentLoc = 0
            node = head
            while case let next? = node.next, currentLoc != index {
                node = next
                currentLoc += 1
            }
        }
        return node.data
    }
}
