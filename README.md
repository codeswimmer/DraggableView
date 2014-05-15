DraggableView
=============

iOS UIView drag &amp; drop library

##### Features:
* Easily add ability to drag around a <code>UIView</code>
    * Other UI components can be dragged as well through implementing a <code>@protocol</code>
* Make any UI component a drop target via a <code>@protocol</code>
* Built-in animations for when a drag ends and when a drop is accepted
    * Which can be augmented or replaced via blocks

##### Using
* Clone repo
* Drag & drop <code>DraggableView.xcodeproj</code> into your workspace
* Follow [Apple's documentation](https://developer.apple.com/library/ios/technotes/iOSStaticLibraries/Articles/configuration.html) on how to use static libraries in iOS

The library uses ARC. It has been developed using Xcode 5 & tested against iOS 7.x.

##### Examples
The <code>DraggableViewExample</code> project includes an example of how to use <code>DraggableView</code> for dragging a view and dropping it on a drop target, also demonstrating transferral of information from the dragged item to the drop target.

###### Adding Drag & Drop

* Drag-ability: Subclass [DraggableView](https://github.com/KeithErmel/DraggableView/blob/master/DraggableView/DraggableView/Source/DraggableView.h)

* Drop-ready: Implement the [DropTargetDelegate](https://github.com/KeithErmel/DraggableView/blob/master/DraggableView/DraggableView/Source/DraggerGestureRecognizer.h) <code>@protocol</code>.

