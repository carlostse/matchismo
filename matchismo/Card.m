/*
 Card.m
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

#import "Card.h"

@implementation Card

+ (NSArray *)validSuits // no need to expose this method in header
{
    return CARD_SUIT;
}

- (void)dealloc
{
    self.btnCard = nil; // release the retain hold be setter, same as [_btnCard release]
    [super dealloc];
}

+ (Card *)emptyCard
{
    return [Card cardWithValue:CARD_EMPTY_VALUE];
}

+ (Card *)cardWithValue:(NSString *)cardValue
{
    UIButton *card = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    card.titleLabel.font = [UIFont boldSystemFontOfSize:24.0f];
    [card setTitle:CARD_FLIP_TITLE forState:UIControlStateNormal];
    // to be generated with use first flip the card
    // cannot use nil otherwise it will return title for state UIControlStateNormal
    [card setTitle:cardValue forState:UIControlStateSelected];
    [card setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];

    // Since iOS7, the UIButtonTypeRoundedRect = UIButtonTypeSystem.
    // The border, border color and border radius have to be added manually
    if (device.ios7){
        card.layer.borderWidth = 1.0f;
        card.layer.cornerRadius = 5.0f;
        card.layer.borderColor = [[UIColor grayColor] CGColor];
        card.backgroundColor = [UIColor whiteColor];
        [card setBackgroundImage:nil forState:UIControlStateSelected];
    }
    Card *c = [[[Card alloc] init] autorelease];
    c.btnCard = card;
    return c;
}

- (void)randomTitle
{
    NSMutableString *title = [[NSMutableString alloc] initWithCapacity:3];
    u_int32_t idx = arc4random() % 13 + 1;
    switch (idx) {
            // 1, 11, 12 and 13 should be A, J, Q, K respectively
        case 13: [title appendString:@"K"]; break;
        case 12: [title appendString:@"Q"]; break;
        case 11: [title appendString:@"J"]; break;
        case 1:  [title appendString:@"A"]; break;
        default: [title appendFormat:@"%i", idx]; break;
    }
    [title appendString:Card.validSuits[arc4random() % Card.validSuits.count]];
    [self.btnCard setTitle:title forState:UIControlStateSelected];
    [title release];
}

- (NSString *)value
{
    return [self.btnCard titleForState:UIControlStateSelected];
}

- (BOOL)emptyValue
{
    NSString *s = self.value;
    return !s || [CARD_EMPTY_VALUE compare:s] == NSOrderedSame;
}

- (void)clearValue
{
    // cannot use nil otherwise it will return title for state UIControlStateNormal
    [self.btnCard setTitle:CARD_EMPTY_VALUE forState:UIControlStateSelected];
}

- (void)disable
{
    [self.btnCard setTitle:self.value forState:UIControlStateNormal];
    self.btnCard.alpha = CARD_DISABLE_ALPHA;
    self.btnCard.enabled = NO;
}

- (void)reset
{
    self.btnCard.alpha = 1.0f;
    self.btnCard.enabled = YES;
    self.btnCard.selected = NO;
    [self.btnCard setTitle:CARD_EMPTY_VALUE forState:UIControlStateSelected];
    [self.btnCard setTitle:CARD_FLIP_TITLE forState:UIControlStateNormal];
}

- (CardCompareResult)compare:(Card *)card
{
    NSString *v1 = self.value;
    NSString *v2 = card.value;
    NSString *suit1 = [v1 substringFromIndex:v1.length - 1];
    NSString *suit2 = [v2 substringFromIndex:v2.length - 1];
    
    if ([suit1 compare:suit2] == NSOrderedSame){
        NSLog(@"[Card] suit %@ vs %@ = same suit", suit1, suit2);
        // because no identical cards, can direct return result here
        return sameSuit;
    }
    
    NSString *rank1 = [v1 substringToIndex:v1.length - 1];
    NSString *rank2 = [v2 substringToIndex:v2.length - 1];
    if ([rank1 compare:rank2] == NSOrderedSame){
        NSLog(@"[Card] num %@ vs %@ = same rank", suit1, suit2);
        return sameRank;
    }
    
    return different;
}

@end
