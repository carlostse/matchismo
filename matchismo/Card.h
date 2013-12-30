/*
 Card.h
 matchismo
 
 Copyright 2013 Carlos Tse <copperoxide@gmail.com>
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/

#define CARD_FLIP_TITLE @""
#define CARD_EMPTY_VALUE @""
#define CARD_SUIT @[@"♠", @"♥", @"♣", @"♦"]
#define CARD_DISABLE_ALPHA 0.3f

#define GAME_MARK_ADJ_FLIP -1
#define GAME_MARK_ADJ_SAME_SUIT 6
#define GAME_MARK_ADJ_SAME_RANK 14

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM (ushort, CardCompareResult){
    different,
    sameRank,
    sameSuit
};

@interface Card : NSObject /*UIButton*/

@property (nonatomic, retain) UIButton *btnCard;

+ (Card *)emptyCard;

// static function, can be used for unit test for the game over algorithm
+ (Card *)cardWithValue:(NSString *)cardValue;

- (void)randomTitle;

- (NSString *)value;

- (BOOL)emptyValue;

- (void)clearValue;

- (void)disable;

- (void)reset;

- (CardCompareResult)compare:(Card *)card;

@end
