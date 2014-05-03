//
//  DraggerGestureRecognizer.m
//  Cauldron
//
//  Created by Keith Ermel on 10/29/13.
//  Copyright (c) 2013 Keith Ermel. All rights reserved.
//

#import "DraggerGestureRecognizer.h"


@interface DraggerGestureRecognizer ()
@property (nonatomic, readonly) UIView<DraggedItemDelegate> *draggedDelegate;
@property (nonatomic) UIView<DraggedItemDelegate> *draggedView;
@property (nonatomic) CGPoint touchOffset;
@end


@implementation DraggerGestureRecognizer

#pragma mark - UIGestureRecognizer

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    self.draggedView = (UIView<DraggedItemDelegate> *)[self.draggedDelegate didBeginDrag:touches];
    [self beginDrag:touches];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    // TODO: hitTestDropTargets to see if the view being dragged is over
    // any of the drop targets
    
    [self moveDraggedView:touches];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    if ([self.draggedDelegate respondsToSelector:@selector(didCancelDrag:)]) {
        [self.draggedDelegate didCancelDrag:touches];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UIView<DropTargetDelegate> *droppedOn = [self hitTestDropTargets:touches];
//    NSLog(@"touchesEnded:\n    draggedItem = %p\n      droppedOn = %p", self.draggedView, droppedOn);
    
    NSDictionary *data;
    if ([self.draggedView respondsToSelector:@selector(willDropOn:)]) {
        data = [self.draggedView willDropOn:droppedOn];
    }
    
    BOOL dropTargetAcceptedDrop = [droppedOn acceptDrop:self.draggedView data:data];
//    NSLog(@"dropTargetAcceptedDrop: %@", dropTargetAcceptedDrop?@"YES":@"NO");

    if ([self.draggedDelegate respondsToSelector:@selector(didEndDrag:dropTarget:)]) {
        [self.draggedDelegate didEndDrag:touches dropTarget:droppedOn];
    }
    
    if (dropTargetAcceptedDrop) {
        if (self.dropAcceptedAnimation == nil) {[self configureDefaultDropAcceptedAnimation];}
        else {self.dropAcceptedAnimation(^(BOOL finished){return YES;});}
    }
    else {
        if (self.dragEndedAnimation == nil) {[self configureDefaultEndedAnimation];}
        self.dragEndedAnimation(^(BOOL finished){return YES;});
    }
}


#pragma mark - Internal API

-(void)beginDrag:(NSSet *)touches
{
    UITouch *touchObject = [touches anyObject];
    CGPoint touchPoint = [touchObject locationInView:self.draggedView.superview];
    
    self.touchOffset = CGPointMake(self.draggedView.center.x - touchPoint.x,
                                   self.draggedView.center.y - touchPoint.y);
    
    _originalCenter = self.draggedView.center;
    _originalFrame = self.draggedView.frame;
    _originalAlpha = self.draggedView.alpha;
    
    [self.draggedView.superview bringSubviewToFront:self.draggedView];
}

-(void)moveDraggedView:(NSSet *)touches
{
    CGPoint point = [touches.anyObject locationInView:self.draggedView.superview];
    CGPoint movePoint = CGPointMake(point.x + self.touchOffset.x,
                                    point.y + self.touchOffset.y);
    self.draggedView.center = movePoint;
}

-(UIView<DropTargetDelegate> *)hitTestDropTargets:(NSSet *)touches
{
    UIView<DropTargetDelegate> *droppedOn;
    
    for (UIView *view in self.view.superview.subviews) {
        UIView<DropTargetDelegate> *dropTarget = [self castToDropTargetDelegate:view];
        
        if (dropTarget) {
            if ([self isAbleToAcceptDrop:view]) {
                BOOL willAccept = [dropTarget willAcceptDrop:self.draggedView];
                
                if (willAccept) {
                    CGPoint point = [touches.anyObject locationInView:view];
                    BOOL didHit = [view pointInside:point withEvent:nil];
                    if (didHit) {
                        return dropTarget;
                    }
                }
            }
        }
    }
    
    return droppedOn;
}

-(BOOL)isAbleToAcceptDrop:(UIView *)view
{
    return [self isDropTargetDelegate:view.class] && view != self.draggedView;
}

-(BOOL)isDropTargetDelegate:(Class)klass
{
    return [klass conformsToProtocol:@protocol(DropTargetDelegate)];
}

-(UIView<DropTargetDelegate> *)castToDropTargetDelegate:(UIView *)view
{
    UIView<DropTargetDelegate> *dropTarget = nil;
    if ([self isDropTargetDelegate:view.class]) {dropTarget = (UIView<DropTargetDelegate> *)view;}
    return dropTarget;
}

-(void)notifyDefaultDropAnimationComplete
{
    if ([self.draggedView respondsToSelector:@selector(defaultDropAcceptedAnimationComplete)]) {
        [self.draggedView defaultDropAcceptedAnimationComplete];
    }
}


#pragma mark - Default Animations

-(void)dropAccepted:(CGPoint)dropPoint completion:(void (^)(BOOL finished))done
{
}

#pragma mark - Configuration

-(void)configureDraggerGestureRecognizer:(UIView<DraggedItemDelegate> *)draggedDelegate
{
    _draggedDelegate = draggedDelegate;
    
    [self configureDefaultEndedAnimation];
    [self configureDefaultDropAcceptedAnimation];
}

-(void)configureDefaultEndedAnimation
{
    __weak DraggerGestureRecognizer *weakSelf = self;
    
    self.dragEndedAnimation = ^(DragAnimationDone done) {
//        NSLog(@"DraggerGestureRecognizer.dragEndedAnimation");
        
        [UIView animateWithDuration:0.2
                         animations:^{weakSelf.draggedView.center = weakSelf.originalCenter;}
                         completion:^(BOOL finished) {if (done) {done(finished);}}];
    };
}

-(void)configureDefaultDropAcceptedAnimation
{
    __weak DraggerGestureRecognizer *weakSelf = self;
    
    self.dropAcceptedAnimation = ^(DragAnimationDone done) {
        [UIView animateWithDuration:0.3
                         animations:^{weakSelf.draggedView.alpha = 0.0;}
                         completion:^(BOOL finished) {
                             [weakSelf notifyDefaultDropAnimationComplete];
                             if (done) {done(finished);}
                         }];
    };
}


#pragma mark - Initialization

-(id)initWithTarget:(id)target
             action:(SEL)action
           delegate:(UIView<DraggedItemDelegate> *)draggedDelegate
{
    self = [super initWithTarget:target action:action];
    if (self) {[self configureDraggerGestureRecognizer:draggedDelegate];}
    return self;
}

@end
