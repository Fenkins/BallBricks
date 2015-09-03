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
