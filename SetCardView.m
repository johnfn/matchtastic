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
    
    int count = [self.count integerValue];
    int symbolHeight = rect.size.height / 6;
    
    [self.color setFill];
    //[[UIBezierPath bezierPathWithOvalInRect:rect] fill];
    
    [self.color setFill];
    
    for (int i = 0; i < count; i++) {
        // This line of code calculates the y position of the symbol, no matter the number of symbols.
        int itemY = rect.size.height/2 - symbolHeight * (count - 1) + i * symbolHeight * 2;
        
        [self drawSymbol:self.symbol inRect:rect atX:rect.size.width/2 atY:itemY];
    }
}

- (void)drawSymbol:(NSString *)symbol inRect:(CGRect)rect atX:(int)x atY:(int)y {
    int offset = rect.size.width / 10;
    int symbolWidth = rect.size.width - offset * 2;
    int symbolHeight = rect.size.height / 6;
    
    // Oval
    if (symbol == @"●") {
        CGRect dest = CGRectMake(x - symbolWidth / 2, y - symbolHeight / 2, symbolWidth, symbolHeight);
        [[UIBezierPath bezierPathWithOvalInRect:dest] fill];
    }
    
    // Diamond
    if (symbol == @"▲") {
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint   :CGPointMake(x, y - symbolHeight / 2)];
        [path addLineToPoint:CGPointMake(x - symbolWidth / 2, y)];
        [path addLineToPoint:CGPointMake(x, y + symbolHeight / 2)];
        [path addLineToPoint:CGPointMake(x + symbolWidth / 2, y)];
        [path closePath];
        [self.color setFill];
        [self.color setStroke];
        [path fill];
        [path stroke];
    }
    
    // Squiggly
    if (symbol == @"■") {
        
    }
}

@end
