//
//  DraggableView.h
//  DragDropSpike
//
//  Created by Keith Ermel on 3/29/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggerGestureRecognizer.h"


@interface DraggableView : UIView<DraggedItemDelegate>
@property (strong, nonatomic, readonly) DraggerGestureRecognizer *dragger;
@end
