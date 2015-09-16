//
//  CCBrick.h
//  BallBricks
//
//  Created by Fenkins on 15/09/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

@interface CCBrick : SKSpriteNode
@property (nonatomic) NSString* brickColor;
@property (nonatomic) int hitCounter;
@end
