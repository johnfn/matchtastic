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

- (void)setShading:(NSNumber *)shading {
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

// The concept for the following two functions were found with modifications from StackOverflow:
// http://stackoverflow.com/questions/2373028/could-someone-please-show-me-how-to-create-a-cgpattern-that-i-can-use-to-stroke

// Make a diagonal line pattern.
void pattern2Callback (void *info, CGContextRef context) {
    UIColor *color = (__bridge UIColor *)info;
    
    UIGraphicsPushContext(context);
    [color setStroke];
    for (int i = 0; i < 20; i += 5) {
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(0, i)];
        [path addLineToPoint:CGPointMake(i, 0)];
        [path stroke];
    }
    UIGraphicsPopContext();
}

// Set the fill to be the diagonal line pattern.
- (void)patternMake2:(CGRect)rect context:(CGContextRef)context
{
    static const CGPatternCallbacks callbacks = { 0, &pattern2Callback, NULL };
    
    CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(context, patternSpace);
    CGColorSpaceRelease(patternSpace);
    CGSize patternSize = CGSizeMake(10, 10);
    CGPatternRef pattern = CGPatternCreate((__bridge void *)(self.color), self.bounds, CGAffineTransformIdentity, patternSize.width, patternSize.height, kCGPatternTilingConstantSpacing, true, &callbacks);
    CGFloat alpha = 1;
    CGContextSetFillPattern(context, pattern, &alpha);
    CGPatternRelease(pattern);
}

- (void)drawSymbol:(NSString *)symbol inRect:(CGRect)rect atX:(int)x atY:(int)y {
    int offset = rect.size.width / 10;
    int symbolWidth = rect.size.width - offset * 2;
    int symbolHeight = rect.size.height / 4;
    UIBezierPath *path;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Oval
    if (symbol == @"●") {
        CGRect dest = CGRectMake(x - symbolWidth / 2, y - symbolHeight / 2, symbolWidth, symbolHeight);
        path = [UIBezierPath bezierPathWithOvalInRect:dest];
    }
    
    // Diamond
    if (symbol == @"♢") {
        path = [[UIBezierPath alloc] init];
        [path moveToPoint   :CGPointMake(x, y - symbolHeight / 2)];
        [path addLineToPoint:CGPointMake(x - symbolWidth / 2, y)];
        [path addLineToPoint:CGPointMake(x, y + symbolHeight / 2)];
        [path addLineToPoint:CGPointMake(x + symbolWidth / 2, y)];
        [path closePath];
    }
    
    // Squiggly (shark???????????)
    if (symbol == @"~") {
        path = [[UIBezierPath alloc] init];
        CGPoint centerPoint = CGPointMake(x, y);
        
        [path moveToPoint   :CGPointMake(x, y - symbolHeight / 2)];
        [path addCurveToPoint:CGPointMake(x - symbolWidth, y) controlPoint1:centerPoint controlPoint2:CGPointMake(x - symbolWidth, y)];
       
        [path addCurveToPoint:CGPointMake(x, y + symbolHeight / 2) controlPoint1:centerPoint controlPoint2:CGPointMake(x, y + symbolHeight)];
        [path addCurveToPoint:CGPointMake(x, y) controlPoint1:centerPoint controlPoint2:CGPointMake(x + symbolWidth, y)];
        
        [path closePath];
    }
    
    [self.color setStroke];
    [path stroke];
    
    if (self.shading == @0) {
        // Solid shading
        [self.color setFill];
        [path fill];
    } else if (self.shading == @1) {
        // Striped shading
        CGContextSaveGState(context);
        [self patternMake2:rect context:UIGraphicsGetCurrentContext()];
        [path fill];
        CGContextRestoreGState(context);
    }
}

@end
