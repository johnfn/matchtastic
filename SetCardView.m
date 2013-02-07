//
//  SetCardView.m
//  Matchismo
//
//  Created by Grant Mathews on 2/6/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "SetCardView.h"


@implementation SetCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setOpaque:NO];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NSLog(@"sup...");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSLog(@"%@", context);
    
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextFillRect(context, self.bounds);
    
    CGContextClearRect(context, rect);
    CGContextStrokeEllipseInRect(context, CGRectMake(25, 25, 175, 175));
    CGContextSetFillColor(context, CGColorGetComponents([[UIColor blueColor] CGColor]));
    CGContextEOFillPath(context);
    
    // Drawing code
}

@end
