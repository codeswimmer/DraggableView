//
//  DVEDraggableView.m
//  DraggableViewExample
//
//  Created by Keith Ermel on 5/2/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import "DVEDraggableView.h"


u_int32_t const kMaxValue = 1000;
u_int32_t const kMinValue = 1;


@interface DVEDraggableView ()
@property (nonatomic) NSInteger value;
@end


@implementation DVEDraggableView

#pragma mark - DraggedItemDelegate

-(UIView *)didBeginDrag:(NSSet *)touches
{
    UIView *dragView = [super didBeginDrag:touches];
    
    self.value = (NSInteger)(arc4random() % (kMaxValue - kMinValue) + kMinValue);
    [self.delegate didSetValue:self.value];
    
    return dragView;
}

-(NSDictionary *)willDropOn:(UIView<DropTargetDelegate> *)dropTarget
{
    NSString *message = [NSString stringWithFormat:@"value: %d", (int)self.value];
    NSLog(@"message: %@", message);
    return @{@"message": message};
}

-(void)defaultDropAcceptedAnimationComplete
{
    [self returnToStartPosition:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{self.alpha = self.dragger.originalAlpha;}
                         completion:^(BOOL finished) {[self.delegate didClearValue];}];
    }];
}

#pragma mark - Internal API

-(void)returnToStartPosition:(void (^)(BOOL finished))done
{
    self.hidden = NO;
    [UIView animateWithDuration:0.2
                     animations:^{self.center = self.dragger.originalCenter;}
                     completion:^(BOOL finished) {done(finished);}];
}

@end
