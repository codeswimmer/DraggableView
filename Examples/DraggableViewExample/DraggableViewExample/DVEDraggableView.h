//
//  DVEDraggableView.h
//  DraggableViewExample
//
//  Created by Keith Ermel on 5/2/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import "DraggableView/DraggableView.h"


@protocol DVEDraggableViewDelegate <NSObject>
-(void)didSetValue:(NSInteger)value;
-(void)didClearValue;
@end


@interface DVEDraggableView : DraggableView
@property (weak, nonatomic) id<DVEDraggableViewDelegate> delegate;
@end
