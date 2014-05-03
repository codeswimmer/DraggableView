//
//  DVEDropTargetView.m
//  DraggableViewExample
//
//  Created by Keith Ermel on 5/2/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import "DVEDropTargetView.h"


@implementation DVEDropTargetView

#pragma mark - DropTargetDelegate

-(BOOL)willAcceptDrop:(UIView<DraggedItemDelegate> *)draggedItem
{
    return YES;
}

-(BOOL)acceptDrop:(UIView<DraggedItemDelegate> *)draggedItem data:(NSDictionary *)data
{
    NSString *message = data[@"message"];
    [self.delegate didAcceptDrop:message];
    return YES;
}


@end
