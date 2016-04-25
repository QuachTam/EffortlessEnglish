//
//  RWLabel.m
//  DeviantArtBrowser
//
//  Created by eagle on 14/8/16.
//  Copyright (c) 2014年 Razeware, LLC. All rights reserved.
//

#import "RWLabel.h"

@implementation RWLabel

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.numberOfLines == 0) {
        
        // If this is a multiline label, need to make sure
        // preferredMaxLayoutWidth always matches the frame width
        // (i.e. orientation change can mess this up)
        
        if (self.preferredMaxLayoutWidth != self.frame.size.width) {
            self.preferredMaxLayoutWidth = self.frame.size.width;
            [self setNeedsUpdateConstraints];
        }
    }
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    
    if (self.numberOfLines == 0) {
        
        // There's a bug where intrinsic content size
        // may be 1 point too short
        
        size.height += 1;
    }
    
    return size;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    // If this is a multiline label, need to make sure
    // preferredMaxLayoutWidth always matches the frame width
    // (i.e. orientation change can mess this up)
    
    if (self.numberOfLines == 0 && bounds.size.width != self.preferredMaxLayoutWidth) {
        self.preferredMaxLayoutWidth = self.bounds.size.width;
        [self setNeedsUpdateConstraints];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
