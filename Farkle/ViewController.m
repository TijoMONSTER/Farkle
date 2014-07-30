//
//  ViewController.m
//  Farkle
//
//  Created by Iván Mervich on 7/30/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "ViewController.h"
#import "DieLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma IBActions

- (IBAction)onRollButtonPressed:(UIButton *)sender
{
	for (DieLabel *dieLabel in self.view.subviews) {

		if ([dieLabel isKindOfClass:[DieLabel class]]) {
			[dieLabel roll];
		}
	}
}

@end
