//
//  CCBrick.m
//  BallBricks
//
//  Created by Fenkins on 15/09/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import "CCBrick.h"

@implementation CCBrick

static const uint32_t kCCBlueBrickCategory      = 0x1 << 3;
static const uint32_t kCCGreenBrickCategory     = 0x1 << 4;
static const uint32_t kCCPurpleBrickCategory    = 0x1 << 5;

-(id)initWithImageNamed:(NSString *)name {
    self = [super init];
    if (self) {
        if ([name isEqualToString:@"blueBrick"]) {
            self.brickColor = @"blue";
            self = [CCBrick spriteNodeWithImageNamed:@"blueBrick"];
            self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width, self.size.height)];
            self.physicsBody.categoryBitMask = kCCBlueBrickCategory;
            self.physicsBody.restitution = 1.0;
            self.physicsBody.collisionBitMask = 0;
            self.hitCounter = 0;

        } else if ([name isEqualToString:@"greenBrick"]) {
            self.brickColor = @"green";
            self = [CCBrick spriteNodeWithImageNamed:@"greenBrick"];
            self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width, self.size.height)];
            self.physicsBody.categoryBitMask = kCCGreenBrickCategory;
            self.physicsBody.restitution = 1.0;
            self.physicsBody.collisionBitMask = 0;
            self.hitCounter = 0;
        } else if ([name isEqualToString:@"purpleBrick"]) {
            self.brickColor = @"purple";
            self = [CCBrick spriteNodeWithImageNamed:@"purpleBrick"];
            self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width, self.size.height)];
            self.physicsBody.categoryBitMask = kCCPurpleBrickCategory;
            self.physicsBody.restitution = 1.0;
            self.physicsBody.collisionBitMask = 0;
            self.hitCounter = 0;
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
