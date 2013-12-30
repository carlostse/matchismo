/*
 CardGameViewController.h
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

#define CARD_PADDING (device.screenWidth * 5.0f / device.screenWidth)

#import "Deck.h"
#import "Score.h"

@interface CardGameViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, retain) UILabel *lblFlip, *lblScore;

@property (nonatomic, assign) int flipCount, score;

@property (nonatomic, retain) Deck *deck;

@end
