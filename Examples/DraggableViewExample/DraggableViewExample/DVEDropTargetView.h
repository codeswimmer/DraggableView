//
//  DVEDropTargetView.h
//  DraggableViewExample
//
//  Created by Keith Ermel on 5/2/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggableView/DraggerGestureRecognizer.h"


@protocol DVEDropTargetViewDelegate <NSObject>
-(void)didAcceptDrop:(NSString *)message;
@end

@interface DVEDropTargetView : UIView<DropTargetDelegate>
@property (weak, nonatomic) id<DVEDropTargetViewDelegate> delegate;
@end
