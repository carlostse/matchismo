/*
 Util.h
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

#define APP_DELEGATE [[UIApplication sharedApplication] delegate]

@interface Util : NSObject

@end

@interface NSDate(NSDateUtil)

- (NSString *)formattedDate;

@end

@interface UIColor(UIColorUtil)

+ (UIColor *)colorWithHex:(NSString *)hex; // #RRGGBB

@end

@interface UIImage(ImageUtil)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end