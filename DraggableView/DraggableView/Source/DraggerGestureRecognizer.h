//
//  DraggerGestureRecognizer.h
//  Cauldron
//
//  Created by Keith Ermel on 10/29/13.
//  Copyright (c) 2013 Keith Ermel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

//void (^)(void))animations

typedef BOOL(^DragAnimationDone)(BOOL finished);
typedef void(^DragEndedAnimation)(DragAnimationDone done);
typedef void(^DropAcceptedAnimation)(DragAnimationDone done);


@class DraggerGestureRecognizer;
@protocol DraggedItemDelegate;

@protocol DropTargetDelegate <NSObject>
-(BOOL)willAcceptDrop:(UIView<DraggedItemDelegate> *)draggedItem;
-(BOOL)acceptDrop:(UIView<DraggedItemDelegate> *)draggedItem data:(NSDictionary *)data;

@optional
-(void)isBeingDraggedOverBy:(UIView<DraggedItemDelegate> *)draggedItem;
@end


@protocol DraggedItemDelegate <NSObject>
-(UIView *)didBeginDrag:(NSSet *)touches;

@optional
-(void)didMoveDraggedItem:(NSSet *)touches;
-(NSDictionary *)willDropOn:(UIView<DropTargetDelegate> *)dropTarget;
-(void)didCancelDrag:(NSSet *)touches;
-(void)didEndDrag:(NSSet *)touches
       dropTarget:(id<DropTargetDelegate>)droppedOn;
-(void)defaultDropAcceptedAnimationComplete;
@end


@interface DraggerGestureRecognizer : UIGestureRecognizer
@property (nonatomic, readonly) CGPoint originalCenter;
@property (nonatomic, readonly) CGRect originalFrame;
@property (nonatomic, readonly) CGFloat originalAlpha;

@property (strong, nonatomic) DragEndedAnimation dragEndedAnimation;
@property (strong, nonatomic) DropAcceptedAnimation dropAcceptedAnimation;

-(id)initWithTarget:(id)target
             action:(SEL)action
           delegate:(id<DraggedItemDelegate>)draggedDelegate;

@end
