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

- (void)setColor:(UIColor *)color {
    [self setNeedsDisplay];
    _color = color;
}

- (void)setCount:(NSNumber *)count {
    [self setNeedsDisplay];
    _count = count;
}

- (void)setShading:(UIColor *)shading {
    [self setNeedsDisplay];
    _shading = shading;
}

- (void)setSymbol:(NSString *)symbol {
    [self setNeedsDisplay];
    _symbol = symbol;
}

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
    if (self.color == nil) {
        // haven't been initialized yet.
        return;
    }
    
    NSLog(@"Good, we have color and calling drawRect");
    
    [[UIColor orangeColor] setFill];
    [[UIBezierPath bezierPathWithOvalInRect:rect] fill];
}

@end
