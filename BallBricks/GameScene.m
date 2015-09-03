//
//  GameScene.m
//  BallBricks
//
//  Created by Fenkins on 01/09/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene {
    SKSpriteNode *topBarLayer;
    SKSpriteNode *paddleBlue;
}

-(void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor whiteColor];
    [self addDefaultSceneElements];
}

-(void)addDefaultSceneElements {
    topBarLayer = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(self.size.width, 30)];
    topBarLayer.position = CGPointMake(self.size.width/2, self.size.height-topBarLayer.size.height/2);
    [self addChild:topBarLayer];
    
    paddleBlue = [SKSpriteNode spriteNodeWithImageNamed:@"paddleBlue"];
    paddleBlue.position = CGPointMake(self.size.width/2, self.size.height/10 + paddleBlue.size.height/2);
    [self addChild:paddleBlue];
}
-(void)addGameMenuElements {
    
}
-(void)addBlocks {
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        // Moving paddle according to the touch moving
        CGPoint touchLocation = [touch locationInNode:self];
        if (touchLocation.x >= self.size.width - paddleBlue.size.width*1/3) {
            paddleBlue.position = CGPointMake(self.size.width - paddleBlue.size.width*1/3, paddleBlue.position.y);
        } else if (touchLocation.x <= paddleBlue.size.width*1/3) {
            paddleBlue.position = CGPointMake(paddleBlue.size.width*1/3, paddleBlue.position.y);
        } else {
            paddleBlue.position = CGPointMake(touchLocation.x, paddleBlue.position.y);
        }
        // End of paddle moving section
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
