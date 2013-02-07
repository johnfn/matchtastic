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
        [self setBackgroundColor:[UIColor redColor]];
        [self setOpaque:NO];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor orangeColor] setFill];
    [[UIBezierPath bezierPathWithOvalInRect:rect] fill];
}

@end
