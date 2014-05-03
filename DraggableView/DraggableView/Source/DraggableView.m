//
//  DraggableView.m
//  DragDropSpike
//
//  Created by Keith Ermel on 3/29/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import "DraggableView.h"

@interface DraggableView ()
@end


@implementation DraggableView

#pragma mark - DraggedItemDelegate

-(UIView<DraggedItemDelegate> *)didBeginDrag:(NSSet *)touches
{
    return self;
}


#pragma mark - Actions

-(void)draggerAction:(UIGestureRecognizer *)gestureRecognizer{}


#pragma mark - Configuration

-(void)configureDragger
{
    _dragger = [[DraggerGestureRecognizer alloc] initWithTarget:self
                                                         action:@selector(draggerAction:)
                                                       delegate:self];
    [self addGestureRecognizer:self.dragger];
}


#pragma mark - Initialization

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {[self configureDragger];}
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {[self configureDragger];}
    return self;
}

@end
