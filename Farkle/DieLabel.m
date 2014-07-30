//
//  DieLabel.m
//  Farkle
//
//  Created by Iván Mervich on 7/30/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "DieLabel.h"

@implementation DieLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)roll
{
	int randomNum = (arc4random() % 6 ) + 1;
	self.text = [NSString stringWithFormat:@"%d", randomNum];
}

#pragma mark IBActions

- (IBAction)onTapped:(id)sender
{

}


@end
