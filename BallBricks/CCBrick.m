//
//  CCBrick.m
//  BallBricks
//
//  Created by Fenkins on 15/09/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import "CCBrick.h"

@implementation CCBrick

static const uint32_t kCCBallCategory           = 0x1 << 0;
static const uint32_t kCCPowerUpCategory        = 0x1 << 1;
static const uint32_t kCCEdgeCategory           = 0x1 << 2;
static const uint32_t kCCBlueBrickCategory      = 0x1 << 3;
static const uint32_t kCCGreenBrickCategory     = 0x1 << 4;
static const uint32_t kCCPurpleBrickCategory    = 0x1 << 5;
static const uint32_t kCCPaddleCategory         = 0x1 << 6;

-(id)initWithImageNamed:(NSString *)name {
    self = [super init];
    if (self) {
        if ([name isEqualToString:@"blueBrick"]) {
            self.brickColor = @"blue";
            self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width, self.size.height)];
            self.physicsBody.categoryBitMask = kCCBlueBrickCategory;
        } else if ([name isEqualToString:@"greenBrick"]) {
            self.brickColor = @"green";
            self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width, self.size.height)];
            self.physicsBody.categoryBitMask = kCCGreenBrickCategory;
        } else if ([name isEqualToString:@"purpleBrick"]) {
            self.brickColor = @"purple";
            self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width, self.size.height)];
            self.physicsBody.categoryBitMask = kCCPurpleBrickCategory;
        }
    }
    return self;
}

-(void)setBrickColor:(NSString *)brickColor {
    _brickColor = brickColor;
}

-(void)setHitCounter:(int)hitCounter {
    _hitCounter = hitCounter;
}

@end
