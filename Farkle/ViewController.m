//
//  ViewController.m
//  Farkle
//
//  Created by Iván Mervich on 7/30/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "ViewController.h"
#import "DieLabel.h"

@interface ViewController () <DieLabelDelegate>

@property NSMutableArray *dice;
@property BOOL firstRoll;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.firstRoll = YES;
	self.dice = [NSMutableArray array];

	for (DieLabel *dieLabel in self.view.subviews) {

		if ([dieLabel isKindOfClass:[DieLabel class]]) {
			dieLabel.delegate = self;
		}
	}
}

#pragma mark DieLabelDelegate

- (void)didChooseDie:(id)dieLabel
{
	// prevent from selecting on the first roll
	if (!self.firstRoll) {

		// add die to array and change backgroundColor
		if (![self.dice containsObject:dieLabel]) {

			DieLabel *label = (DieLabel *)dieLabel;
			[self.dice addObject:label];
			label.backgroundColor = [UIColor redColor];
		}
	}
}

#pragma mark IBActions

- (IBAction)onRollButtonPressed:(UIButton *)sender
{
	if (self.firstRoll) {
		self.firstRoll = NO;
	}

	// roll the dice that aren't in the array
	for (DieLabel *dieLabel in self.view.subviews) {

		if ([dieLabel isKindOfClass:[DieLabel class]]) {

			if (![self.dice containsObject:dieLabel]) {
				[dieLabel roll];
			}
		}
	}

	// clear the array
	for (DieLabel *dieLabel in self.dice) {
		dieLabel.backgroundColor = [UIColor orangeColor];
	}

	[self.dice removeAllObjects];
}

@end
