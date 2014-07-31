//
//  DieLabel.m
//  Farkle
//
//  Created by Iván Mervich on 7/30/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "DieLabel.h"

@implementation DieLabel

- (void)roll
{
	int randomNum = (arc4random() % 6 ) + 1;
	self.text = [NSString stringWithFormat:@"%d", randomNum];
}

#pragma mark IBActions

- (IBAction)onTapped:(id)sender
{
	[self.delegate didChooseDie:self];
}


@end
