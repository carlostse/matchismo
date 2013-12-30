/*
 CardGameViewController.m
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

#import "CardGameViewController.h"

@interface CardGameViewController ()

@end

@implementation CardGameViewController

- (id)init
{
    self = [super init];
    if (self) {
        // pepare the deck
        Deck *deck = [[Deck alloc] init];
        self.deck = deck; // the setter will retain it
        [deck release];
    }
    return self;
}

- (void) dealloc
{
    self.lblFlip = nil; // same as [_lblFlip release];
    self.lblScore = nil; // same as [_lblScore release];
    self.deck = nil; // same as [_deck release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHex:@"#64937D"];

    // parepare the cards
    [self prepareCards];

    // common for labels
    CGSize lblSize = CGSizeMake(80, 20);
    float lblY = device.screenHeight - lblSize.height - TAB_BAR_H - CARD_PADDING;

    // flips label
    CGRect lblFlipRect = {CGPointMake(10, lblY), lblSize};
    UILabel *lblFlip = [[UILabel alloc] initWithFrame:lblFlipRect];
    lblFlip.backgroundColor = [UIColor clearColor];
    lblFlip.font = [UIFont systemFontOfSize:15.0f];
    self.lblFlip = lblFlip;
    [lblFlip release];
    [self.view addSubview:self.lblFlip];
    
    // score label
    CGRect lblScoreRect = {CGPointMake(device.screenWidth - lblSize.width - 10, lblY), lblSize};
    UILabel *lblScore = [[UILabel alloc] initWithFrame:lblScoreRect];
    lblScore.backgroundColor = [UIColor clearColor];
    lblScore.font = [UIFont systemFontOfSize:15.0f];
    self.lblScore = lblScore;
    [lblScore release];
    [self.view addSubview:self.lblScore];

    // show flip = 0 and score = 0 in order to update the label text
    self.flipCount = 0;
    self.score = 0;
    
    self.deck.flipCardResultHandler = ^(CardCompareResult result){
        if (result == sameSuit){
            self.score += GAME_MARK_ADJ_SAME_SUIT;
        } else if (result == sameRank){
            self.score += GAME_MARK_ADJ_SAME_RANK;
        }
    };

    self.deck.gameOverHandler = ^(){
        NSString *str = [NSString stringWithFormat:@"Game Over\nYour Score: %i", self.score];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:nil message:str
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    };
}

- (void)prepareCards
{
    // x and y for each card. Left and right padding is twice as padding between cards
    float x = CARD_PADDING * 2, y = CARD_PADDING * 2;

    // offset 20 for the status bar for iOS7
    if (device.ios7){
        y += 20;
#ifdef DEBUG
        NSLog(@"[CardGameViewController] offset 20 for iOS 7");
#endif
    }

    // card width = (screen width - left and right padding - cards padding) / num of cards in one row
    float
    cardW = (device.screenWidth - x * 2 - (CARD_NUM_OF_COL - 1) * CARD_PADDING) / CARD_NUM_OF_COL,
    cardH = cardW * 1.5; // make height twice as width
    CGSize size = {cardW, cardH};
    NSLog(@"[CardGameViewController] card size: %f x %f", cardW, cardH);

    NSArray *cards = self.deck.cards;
    for (int i = 0, cardIdx = 0; i < CARD_NUM_OF_ROW; i++) {
        // reset x per row
        x = CARD_PADDING * 2;

        for (int j = 0; j < CARD_NUM_OF_COL; j++, cardIdx++) {
            CGRect rect = {CGPointMake(x, y), size};
            x += cardW + CARD_PADDING;

            // add card to view
            Card *card = [cards objectAtIndex:cardIdx];
            card.btnCard.frame = rect;
            card.btnCard.tag = cardIdx;
            [card.btnCard addTarget:self action:@selector(flipCard:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:card.btnCard];
        }
        y += cardH + CARD_PADDING;
    }
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.lblFlip.text = [NSString stringWithFormat:@"Flips: %i", flipCount];
}

- (void)setScore:(int)score
{
    _score = score;
    self.lblScore.text = [NSString stringWithFormat:@"Score: %i", score];
}

#pragma mark - IBAction

- (IBAction)flipCard:(UIButton *)sender
{
    // cannot flip card right now because the card match algorithm is under processing
    if (self.deck.suspenFlipCard)
        return;
    
    // different from the example,
    // here, we don't allow turn over the flip card (i.e, cancel the same flip card)
    if (sender.selected)
        return;

    sender.selected = YES;
    self.score += GAME_MARK_ADJ_FLIP; /* GAME_MARK_ADJ_FLIP = -1 */
    [self.deck flipCardAtIndex:sender.tag];
    [self.deck compareCards];
    self.flipCount++;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"save score %i", self.score);
    [Score save:self.score];

    // reset score, flip count and cards
    self.score = 0;
    self.flipCount = 0;
    [self.deck reset];

    // switch to tab 2 for viewing score
    self.tabBarController.selectedIndex = 1;
}

@end
