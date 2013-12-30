/*
 Deck.h
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

// "1. There should be 3 rows with 4 cards in each row"
#define CARD_NUM_OF_ROW 3
#define CARD_NUM_OF_COL 4

#import "Card.h"

@interface Deck : NSObject

// "2. each card generated should be unique"
// use a dictionary to ensure the cards returned are unique
@property (nonatomic, retain) NSMutableDictionary *dict;

// "3. each card should retain its value after the first flip"
// use an array to store the generated cards, fast in index retrieval
@property (nonatomic, retain) NSArray *cards;

// init once and cache it
@property (nonatomic, retain) NSArray *validSuits;

// the previous and current flip card, no need to retain it
@property (nonatomic, assign) Card *pCard, *cCard;

// the block for handle flip card comparison result
@property (nonatomic, copy) void (^flipCardResultHandler)(CardCompareResult result);

// the block for handle game over
@property (nonatomic, copy) void (^gameOverHandler)();

// suspend user to flip another card while the comparing is in processing.
// This is a thread-safe property
@property (atomic, assign) BOOL suspenFlipCard;

// "2. the program should be able to randomly generate a card when a card is flipped the first time."
// i.e., lazy instantiation, therefore, here will return a single card instead of card array.
- (void)flipCardAtIndex:(uint)index;

- (void)compareCards;

- (void)flipOverCards;

// static function, can be used for unit test for the game over algorithm
+ (BOOL)matchCards:(NSArray *)array;

- (void)reset;

@end
