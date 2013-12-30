/*
 ScoreViewController.m
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

#import "ScoreViewController.h"

@interface ScoreViewController ()

@end

@implementation ScoreViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    self.scores = nil; // same as [_scores release]
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    float y = device.ios7? 20.: 0.;

    // use ivar to init and release
    _tbl = [[UITableView alloc] initWithFrame:CGRectMake(0, y, device.screenWidth, device.screenHeight - TAB_BAR_H - y)];
    self.tbl.dataSource = self;
    [self.view addSubview:self.tbl];
    [_tbl release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSArray *arr = [Score newScoreList];
    self.scores = arr;
    [arr release];
    NSLog(@"score count: %i", self.scores.count);
    
    [self.tbl reloadData];
}

- (NSString *)rankSuffix:(uint)rank
{
    switch (rank) {
        case 1:  return @"st";
        case 2:  return @"nd";
        case 3:  return @"rd";
        default: return @"th";
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.scores.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"High Score";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScoreTableCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:@"Courier-Bold" size:18.0f];
    }

    int row = indexPath.row, rank = row + 1;
    Score *obj = [self.scores objectAtIndex:row];
    NSString *date = obj.date.formattedDate;
#ifdef DEBUG
    NSLog(@"[%i] %i - %@", row, obj.score, date);
#endif
    cell.textLabel.text = [NSString stringWithFormat:@"%i%@ %4i", rank, [self rankSuffix:rank], obj.score];
    cell.detailTextLabel.text = date;
    return cell;
}

@end
