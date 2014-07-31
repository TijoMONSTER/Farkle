//
//  Player.m
//  Farkle
//
//  Created by Iván Mervich on 7/30/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Player.h"

@implementation Player

- (instancetype)initWithName:(NSString *)name
{
	self = [super init];

	self.name = name;
	self.score = 0;

	return self;
}

@end
