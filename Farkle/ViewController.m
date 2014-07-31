//
//  ViewController.m
//  Farkle
//
//  Created by Iván Mervich on 7/30/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "ViewController.h"
#import "DieLabel.h"
#import "Player.h"

@interface ViewController () <DieLabelDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;

@property (weak, nonatomic) IBOutlet UIButton *endTurnButton;

@property NSMutableArray *dice;
@property BOOL firstRoll;

@property NSMutableArray *lastThrowDice;
@property int lastThrowScore;

@property NSArray *players;
@property Player *currentPlayer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.dice = [NSMutableArray array];

	// set label delegates
	for (DieLabel *dieLabel in self.view.subviews) {

		if ([dieLabel isKindOfClass:[DieLabel class]]) {
			dieLabel.delegate = self;
		}
	}

	self.firstRoll = YES;

	self.lastThrowDice = [NSMutableArray array];
	self.lastThrowScore = 0;

	Player *player1 = [[Player alloc] initWithName:@"Player 1"];
	Player *player2 = [[Player alloc] initWithName:@"Player 2"];

	self.players = @[player1, player2];
	self.currentPlayer = player1;

	[self startTurn];

}

#pragma mark DieLabelDelegate

- (void)didChooseDie:(id)dieLabel
{
	// prevent from selecting on the first roll
	if (!self.firstRoll) {

		// you can't reselect a die that was selected last throw
		if ([self.lastThrowDice containsObject:dieLabel]) {
			return;
		}

		if ([self checkIfDieCanScore:dieLabel]) {


			DieLabel *die = (DieLabel *)dieLabel;

			// add die to array and change backgroundColor
			if (![self.dice containsObject:dieLabel]) {
				NSLog(@"Die scores, can be selected");
				[self.dice addObject:die];
				die.backgroundColor = [UIColor redColor];
				self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.lastThrowScore + [self scoreForDice:self.dice]];
				self.endTurnButton.hidden = NO;
			}

			//hot dice

			if ([self.dice count] == 6) {
				UIAlertView *alertView = [[UIAlertView alloc] init];
				alertView.message = @"Hot dice, throw 6 dice again!";
				[alertView addButtonWithTitle:@"Awesome!"];
				[alertView show];


				if ([self.lastThrowDice count] > 0) {
					[self.lastThrowDice removeAllObjects];
					self.lastThrowScore = 0;
				}
				if ([self.dice count] > 0) {
					[self.dice removeAllObjects];
				}

				// add score to the player
				self.currentPlayer.score += [self.scoreLabel.text intValue];

				[self checkWinner];

				NSLog(@"Current player %@ new score: %d", self.currentPlayer.name, self.currentPlayer.score);

				[self endTurnByHotDice];
			}

		} else {
			NSLog(@"nope nope nope");
		}
	}
}

#pragma mark IBActions

- (IBAction)onRollButtonPressed:(UIButton *)sender
{
	if (self.firstRoll) {
		self.firstRoll = NO;

		NSLog(@"first roll");

		for (DieLabel *dieLabel in self.view.subviews) {
			
			if ([dieLabel isKindOfClass: [DieLabel class]]) {
				[dieLabel roll];	
			}
		}
	}
	// player continues game
	else {

		NSLog(@"dice count %d", self.dice.count);
		// check that at least one die is selected
		if ([self.dice count] == 0) {
			UIAlertView *alertView = [[UIAlertView alloc] init];
			alertView.message = @"You must select at least one die.";
			[alertView addButtonWithTitle:@"OK"];
			[alertView show];
			return;
		}

		// roll the dice that aren't in the array
		for (DieLabel *dieLabel in self.view.subviews) {

			if ([dieLabel isKindOfClass:[DieLabel class]]) {

				if (![self.dice containsObject:dieLabel] && ![self.lastThrowDice containsObject:dieLabel]) {
					[dieLabel roll];
				}
	//			else {
					// return it to its original color
	//				dieLabel.backgroundColor = [UIColor orangeColor];
	//			}
			}
		}

		if ([self.dice count] > 0) {
			// send them to another array
			NSLog(@"saving last turn dice");
			[self.lastThrowDice addObjectsFromArray:self.dice];
			self.lastThrowScore = [self scoreForDice:self.lastThrowDice];

			[self.dice removeAllObjects];
		}

		if ([self farkled]) {
			UIAlertView *alertView = [[UIAlertView alloc] init];
			alertView.message = @"Farkle, next player's turn!";
			[alertView addButtonWithTitle:@"OK"];
			[alertView show];

			[self endTurn];
		}
	}

}

- (IBAction)onEndTurnButtonPressed:(UIButton *)sender
{
	// add score to the player
//	self.currentPlayer.score += [self.scoreLabel.text intValue];

	self.currentPlayer.score += (self.lastThrowScore + [self scoreForDice:self.dice]);

	[self checkWinner];

	NSLog(@"Current player %@ new score: %d", self.currentPlayer.name, self.currentPlayer.score);

	if ([self.lastThrowDice count] > 0) {
		[self.lastThrowDice removeAllObjects];
		self.lastThrowScore = 0;
	}
	if ([self.dice count] > 0) {
		[self.dice removeAllObjects];
	}

	[self endTurn];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	// resetPlayers
	for (Player *player in self.players) {
		player.score = 0;
	}

	self.currentPlayer = [self.players objectAtIndex:0];
	[self resetInitialValues];
	[self setUserScoreLabelText];
}


#pragma mark Helper methods

- (void)checkWinner
{
	if (self.currentPlayer.score >= 10000) {
		UIAlertView *alertView = [[UIAlertView alloc] init];
		alertView.message = [NSString stringWithFormat:@"Congratulations, %@ won with %d points!", self.currentPlayer.name, self.currentPlayer.score];
		alertView.delegate = self;
		[alertView addButtonWithTitle:@"Replay"];
		[alertView show];
	}
}

- (int)scoreForDice:(NSArray *)dice
{
	int score = 0;

	int diceCount1 = 0;
	int diceCount2 = 0;
	int diceCount3 = 0;
	int diceCount4 = 0;
	int diceCount5 = 0;
	int diceCount6 = 0;

	for (DieLabel *die in self.dice) {
		if ([die.text isEqualToString:@"1"]) {
			diceCount1++;
		} else if ([die.text isEqualToString:@"2"]) {
			diceCount2++;
		} else if ([die.text isEqualToString:@"3"]) {
			diceCount3++;
		} else if ([die.text isEqualToString:@"4"]) {
			diceCount4++;
		} else if ([die.text isEqualToString:@"5"]) {
			diceCount5++;
		} else if ([die.text isEqualToString:@"6"]) {
			diceCount6++;
		}
	}

	// die 1
	if (diceCount1 >= 3) {
		score += 1000;
	} else {
		score += (diceCount1 * 100);
	}

	// die 2
	if (diceCount2 >= 3) {
		score += 200;
	}

	// die 3
	if (diceCount3 >= 3) {
		score += 300;
	}

	// die 4
	if (diceCount4 >= 3) {
		score += 400;
	}

	//die 5
	if (diceCount5 >= 3) {
		score += 500;
	} else {
		score += (diceCount5 * 50);
	}

	// die 6
	if (diceCount6 >= 3) {
		score += 600;
	}

	return score;
}


- (BOOL)farkled
{
	NSLog(@"checking if farkled");

	int diceWith1 = 0;
	int diceWith2 = 0;
	int diceWith3 = 0;
	int diceWith4 = 0;
	int diceWith5 = 0;
	int diceWith6 = 0;

	for (DieLabel *die in self.view.subviews) {
		if ([die isKindOfClass:[DieLabel class]]) {
			if (![self.lastThrowDice containsObject:die] && ![self.dice containsObject:die]) {
				if ([die.text isEqualToString:@"1"]) {
					diceWith1++;
				}
				else if ([die.text isEqualToString:@"2"]) {
					diceWith2++;
				}
				else if ([die.text isEqualToString:@"3"]) {
					diceWith3++;
				}
				else if ([die.text isEqualToString:@"4"]) {
					diceWith4++;
				}
				else if ([die.text isEqualToString:@"5"]) {
					diceWith5++;
				}
				else if ([die.text isEqualToString:@"6"]) {
					diceWith6++;
				}
			}
		}
	}

	// no dice score, farkled
	return (diceWith1 == 0 &&
			diceWith5 == 0 &&

			diceWith2 < 3 &&
			diceWith3 < 3 &&
			diceWith4 < 3 &&
			diceWith6 < 3);
}


- (BOOL)checkIfDieCanScore:(DieLabel *)die
{
	// it requires only one 1 or 5 to score
	if ([die.text isEqualToString:@"1"] || [die.text isEqualToString:@"5"]) {
		return YES;
	}

	int diceCount = 0;

	for (DieLabel *viewDie in self.view.subviews) {

		if ([viewDie isKindOfClass:[DieLabel class]]) {

			if (![self.lastThrowDice containsObject:viewDie]) {
//			if (![self.dice containsObject:viewDie] && ![self.lastTurnDice containsObject:viewDie]) {

				if ([viewDie.text isEqualToString:die.text]) {
					diceCount ++;
				}

			}
		}
	}

	// if more than 3 occurrences
	return diceCount >= 3;
}

- (void)startTurn 
{
	NSLog(@"start turn, score: %d", self.currentPlayer.score);
	self.playerLabel.text = self.currentPlayer.name;
}

- (void)endTurn 
{
	NSLog(@"end turn");

	[self resetInitialValues];

	[self changePlayer];

	[self setUserScoreLabelText];

	[self startTurn];
}

- (void)endTurnByHotDice
{
	NSLog(@"end turn by hot dice");

	[self resetInitialValues];
	[self setUserScoreLabelText];

	[self startTurn];
}

- (void)resetInitialValues
{
	for (DieLabel *die in self.view.subviews) {

		if ([die isKindOfClass:[DieLabel class]]) {
			die.text = @"1";
			die.backgroundColor = [UIColor orangeColor];
		}
	}

	self.firstRoll = YES;
	self.endTurnButton.hidden = YES;
}

- (void)changePlayer
{
	int currentPlayerIndex = [self.players indexOfObject:self.currentPlayer];

	if (++currentPlayerIndex == [self.players count]) {
		self.currentPlayer = [self.players objectAtIndex:0];
		NSLog(@"Setting current player back to 0");
	}
	else {
		self.currentPlayer = [self.players objectAtIndex:currentPlayerIndex];
		NSLog(@"Setting current player %@", self.currentPlayer.name);
	}


}

#pragma mark Setters

- (void)setUserScoreLabelText
{
	self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.currentPlayer.score];
}

@end
