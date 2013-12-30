/*
 Util.m
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

#import "Util.h"

@implementation Util

@end

@implementation NSDate(NSDateUtil)

- (NSString *)formattedDate
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSString *day = [format stringFromDate:self];
    [format release];
    return day;
}

@end

@implementation UIColor(UIColorUtil)

+ (UIColor *)colorWithHex:(NSString *)hex
{
    if (hex == nil || hex.length != 7)
		return [UIColor clearColor];

	NSString *hexString = [hex uppercaseString],
    *redString = [hexString substringWithRange: NSMakeRange(1, 2)],
    *greenString = [hexString substringWithRange: NSMakeRange(3, 2)],
    *blueString = [hexString substringWithRange: NSMakeRange(5, 2)];

	unsigned red, green, blue;
    [[NSScanner scannerWithString: redString] scanHexInt: &red];
	[[NSScanner scannerWithString: greenString] scanHexInt: &green];
	[[NSScanner scannerWithString: blueString] scanHexInt: &blue];

    return [UIColor colorWithRed:red/255.0F green:green/255.0F blue:blue/255.0F alpha:1.0f];
}

@end

@implementation UIImage(ImageUtil)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end