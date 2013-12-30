/*
 Score.m
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

#import "Score.h"

@implementation Score

- (id)initWithNSManagedObject:(NSManagedObject *)obj;
{
    self = [super init];
    if (self){
        self.score = [[obj valueForKey:SCORE] shortValue];
        self.date = [obj valueForKey:DATE];
    }
    return self;
}

+ (void)save:(short)score
{
    id appDelegate = APP_DELEGATE;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    // insert new score
    NSManagedObject *obj = [NSEntityDescription insertNewObjectForEntityForName:TBL_SCORE inManagedObjectContext:context];

    [obj setValue:[NSNumber numberWithShort:score] forKey:SCORE];
    [obj setValue:[NSDate date] forKey:DATE];

    // if total scores exceeds MAX_SCORE_SAVED, then delete it
    NSArray *result = [Score scoreList];
    if (result){
        for (int i = MAX_SCORE_SAVED; i < result.count; i++) {
            NSManagedObject *obj = [result objectAtIndex:i];
#ifdef DEBUG
            NSLog(@"delete score %i", [[obj valueForKey:SCORE] shortValue]);
#endif
            [context deleteObject:obj];
        }
    }

    // save context immediate prevent data lost
	[appDelegate performSelector:@selector(saveContext)];
}

+ (NSArray */*NSManagedObject * */)scoreList
{
    id appDelegate = APP_DELEGATE;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
	NSEntityDescription *entity = [NSEntityDescription entityForName:TBL_SCORE inManagedObjectContext:context];

    NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:SCORE ascending:NO];
    NSSortDescriptor *sort2 = [[NSSortDescriptor alloc] initWithKey:DATE ascending:NO];
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    req.sortDescriptors = @[sort1, sort2];
    req.fetchLimit = MAX_SCORE_SAVED;
    req.entity = entity;

    NSError *error;
    NSArray *result = [context executeFetchRequest:req error:&error];
	[req release];
    [sort1 release];
    [sort2 release];
    
    return result;
}

+ (NSMutableArray */*<Score>*/)newScoreList
{
    NSArray *result = [Score scoreList];
    if (result){
        NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:[result count]];
        for (NSManagedObject *obj in result) {
            Score *score = [[Score alloc] initWithNSManagedObject:obj];
            [list addObject:score];
            [score release];
        }
		return list;
    }
	return nil;
}

@end
