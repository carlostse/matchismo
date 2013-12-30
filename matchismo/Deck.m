/*
 Deck.m
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

#import "Deck.h"

@implementation Deck

- (id)init
{
    self = [super init];
    if (self) {
        uint totalNumOfCards = CARD_NUM_OF_ROW * CARD_NUM_OF_COL;

        // use a dictionary to ensure the cards returned are unique
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:totalNumOfCards];
        self.dict = dict; // the setter will retain dict
        [dict release];

        self.validSuits = CARD_SUIT; // the setter will retain suits
    }
    return self;
}

- (void)dealloc
{
    self.dict = nil; // same as [_dict release]
    self.cards = nil; // same as [_cards release]
    self.validSuits = nil; // same as [_validSuits release]
    [super dealloc];
}

// override the getter, just-in-time to create cards, i.e., lazy instantiation.
- (NSArray *)cards
{
    // don't use self.cards, otherwise, it will loop back
    if (_cards){
        return _cards;
    }

    uint totalNumOfCards = CARD_NUM_OF_ROW * CARD_NUM_OF_COL;
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:totalNumOfCards];

    for (int i = 0; i < totalNumOfCards; i++) {
        Card *card = Card.emptyCard;
        [arr addObject:card];
        // the object returned from Card.emptyCard is autoreleased.
        // Therefore, don't release card here
    }

    self.cards = arr; // setter will retain cards
    [arr release];

    return _cards;
}

- (void)flipCardAtIndex:(uint)index
{
    // boundary check
    NSLog(@"[Deck] flip index: %i", index);
    if (index >= self.cards.count){
        NSLog(@"[Deck] flipCardAtIndex, out of boundary");
        return;
    }

    // Get card from cards. If the card has value, just return the card
    Card *card = [self.cards objectAtIndex:index];
    self.cCard = card; // record the current card
    if (!card.emptyValue){
        NSLog(@"[Deck] flipCardAtIndex, card generated before, title: %@", card.value);
        return;
    }

    // As per requirements, randomly generate a card when a card is flipped the first time, i.e., lazy instantiation.
    // However, instead of generating all the possible cards then extract from the cards,
    // here, the unique card is created one-by-one
    while (card.emptyValue) {
        [card randomTitle];
        if ([self.dict valueForKey:card.value]){
#ifdef DEBUG
            NSLog(@"[Deck] %@ already generated, re-generate...", card.value);
#endif
            [card clearValue];
        } else {
#ifdef DEBUG
            NSLog(@"[Deck] [%i] %@", index, card.value);
#endif
        }
    }

    [self.dict setObject:card.value forKey:card.value];
    // the object returned from Card.randomCard is autorelease object.
    // So, no need to release it here
}

- (void)compareCards
{
    if (self.pCard && self.cCard){
        CardCompareResult result = [self.pCard compare:self.cCard];
        NSLog(@"[Deck] compare %@ with %@ result: %i", self.pCard.value, self.cCard.value, result);
        self.flipCardResultHandler(result);
        if (result == different){
            // suspen flip card unit the scheduled job finished
            self.suspenFlipCard = YES;

            // auto turn back the cards if they are not matched
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(flipOverCards) userInfo:nil repeats:NO];

        } else {
            // keep the cards opened
            // but user cannot select the cards anyone and change alpha value to 0.3s
            [self.pCard disable];
            [self.cCard disable];
            self.pCard = nil;
            self.cCard = nil;
            // there will be a chance game over, the game over function will handle it
            [self gameOver];
        }
        return;
    }
    self.pCard = self.cCard;
}

- (void)flipOverCards
{
    [self.pCard.btnCard setSelected:NO];
    [self.cCard.btnCard setSelected:NO];
    self.pCard = nil;
    self.cCard = nil;
    // allow use to flip card again
    self.suspenFlipCard = NO;
    // there will be a chance game over, the game over function will handle it
    [self gameOver];
}

- (BOOL)checkGameOver
{
    // an array to store card for game over checking,
    // the array is autoreleased after function end
    // the optimized capcaity is 4, the array size should not max at 4
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:4];

#ifdef DEBUG
    int i = 0;
#endif
    for (Card *card in self.cards){
        if (card && card.btnCard){
            if (card.btnCard.enabled){
                // assert no cards are nil
                NSAssert(card.value, @"[Deck] card value should not be nil");

                // if there are cards with empty value, two cards may be matched,
                // thus, NO will be retured
                if ([card.value compare:CARD_EMPTY_VALUE] == NSOrderedSame){
                    NSLog(@"[Deck] still have some empty cards");
                    return NO;
                }
#ifdef DEBUG
                NSLog(@"[Deck] [%i] value: %@", i, card.value);
#endif
                [arr addObject:card];
                // no need to release card because the array will be released sooner then the card
            }
        }
#ifdef DEBUG
        i++;
#endif
    }

    uint cnt = arr.count;
    NSLog(@"[Deck] array count: %i", cnt);

    if (cnt == 0){
        // if all cards are disabled OR
        // there are cards enabled but not empty values,
        // then game over
        return YES;
    } else {
        // further checking is needed if count equals to 4
        // if no cards can be matched, then game over is YES
        return ![Deck matchCards:arr];
    }
}

- (void)gameOver
{
    if ([self checkGameOver]){
        NSLog(@"[Deck] game over");
        self.gameOverHandler();
    }
}

+ (BOOL)matchCards:(NSArray *)array
{
    uint cnt = array.count;

    // 1st vs 2nd, 2nd vs 3rd, 3rd vs 4th, and
    // 2nd vs 3rd, 2nd vs 4th,
    // then, the matching was done

    for (int j = 0; j < 2; j++) {
        for (int i = j; i < cnt - 1; i++) {
            Card *c1 = [array objectAtIndex:j]; // j, because 1st vs ... and 2nd vs ...
            Card *c2 = [array objectAtIndex:i + 1];
            CardCompareResult result = [c1 compare:c2];
#ifdef DEBUG
            NSLog(@"[Deck] %@ vs %@, result: %i", c1.value, c2.value, result);
#endif
            if (result == sameRank || result == sameSuit){
                return YES;
            }
        }
    }
    return NO;
}

- (void)reset
{
    // reset the cards
    for (Card *card in self.cards) {
        [card reset];
    }

    // empty the dictionary for duplicate checking
    [self.dict removeAllObjects];
}

@end
