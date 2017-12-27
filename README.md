# Swift Queue View Controller

## Overview
A view controller, which visually dequeues it's subviews off of a queue. 

## Reasoning Behind Development
I built this framework specifically for a feature I was using in another app. The app needed to display a predetermined number of songs in the queue for it's music player. When a song was complete, the top song was removed from the queue, and the queue shifted up by 1 to display a new song image.

### Queue View Controller Example
Below is video of the Queue View Controller in action. In this example, the view controller is implemented as a child view controller to the left side of the screen. When a song finishes, the top song image is removed, and the queue shifts up. 

NOTE: The image moving over to the other side of the screen is not a feature of the Queue View Controller. 

<img src="Examples/QueueVideoExample.gif" height="400" width="225">

## Notes
There are still other plans in the works for this controller. I want to allow different default layouts and animations (but I will make these "open" so the user can override and customize them). Plus, I want to do a better write up on this whenever it's finished and I'm not short on time. Another note is some of the code still needs to be cleaned up (animations for sure), but it is functioning properly for the time being. It's on v0.5 for Carthage right now, and when I get the time, I'll layout instruction for that as well.

Here are some basic notes on the controller: 
1. QueueViewController can be subclassed
    + It is an open class, so it's public functions can be overridden.
2. For performance, not all subviews are generated for each item that needs to be shown in the queue; the user specifies the number of items/views to show. When an item is dequeued, the following occurs to the top view in the queue:
    + It moves itselfs outside of the boundaries of the main view.
    + It's property, specified by the user, will be updated with the information that needs to be displayed for the new item at the bottom of the queue.
        * In the example, the image property of the UIImageview is updated offscreen with the new song that will come into the queue.
    + It then moves itself to the bottom of the main view (still outside the bounds), and when it's time, it will slide up into view.
3. The controller was created to be generic with UIView types.
    + The user needs to specify the UIView type that will populate the queue.
    + As of right now, the only properties that can be updated on the UIView are:
        * Image
        * Text
        * Background Color
4. Refer to ViewController.swift for an example on how to use the QueueViewController.
    + In that example, I have a set of UIImageViews with different colors displayed on the screen. There's also a button, which dequeues an image view whenever it is pressed.


