//
//  DVEViewController.m
//  DraggableViewExample
//
//  Created by Keith Ermel on 5/2/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import "DVEViewController.h"
#import "DVEDraggableView.h"
#import "DVEDropTargetView.h"


@interface DVEViewController ()<DVEDropTargetViewDelegate, DVEDraggableViewDelegate>
// Outlets
@property (weak, nonatomic) IBOutlet DVEDraggableView *draggableView;
@property (weak, nonatomic) IBOutlet DVEDropTargetView *dropTargetView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@end


@implementation DVEViewController

#pragma mark - DVEDraggableViewDelegate

-(void)didSetValue:(NSInteger)value
{
    self.valueLabel.text = [NSString stringWithFormat:@"value: %d", (int)value];
    self.messageLabel.text = @"";
}

-(void)didClearValue
{
    self.valueLabel.text = @"";
}


#pragma mark - DVEDropTargetViewDelegate

-(void)didAcceptDrop:(NSString *)message
{
    self.messageLabel.text = message;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.draggableView.delegate = self;
    self.dropTargetView.delegate = self;
}

@end
