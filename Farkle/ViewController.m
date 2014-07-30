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

@property (weak, nonatomic) IBOutlet UILabel *userScore;

@property NSMutableArray *dice;
@property BOOL firstRoll;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	// leave it as NO so checkmate framework is happy
	self.firstRoll = NO;
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
			else {
				// return it to its original color
				dieLabel.backgroundColor = [UIColor orangeColor];
			}
		}
	}

	// clear the array
	[self.dice removeAllObjects];
}

@end
