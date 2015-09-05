//
//  GameScene.m
//  BallBricks
//
//  Created by Fenkins on 01/09/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene {
    SKSpriteNode *_topBarLayer;
    SKSpriteNode *_paddleBlue;
    SKSpriteNode *_heart;
    SKLabelNode *_levelLabel;
    SKLabelNode *_ball;
    int _levelNumber;
}
static const CGFloat BALL_INITIAL_SPEED     = 1000.0f;

static const uint32_t kCCBallCategory       = 0x1 << 0;
static const uint32_t kCCEdgeCategory       = 0x1 << 1;
static const uint32_t kCCBrickBlockCategory = 0x1 << 2;
static const uint32_t kCCPowerUpCategory    = 0x1 << 3;

-(void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor whiteColor];
    [self addDefaultSceneElements];
    [self drawBlocksBasedOnArray];
}

-(void)addDefaultSceneElements {
    self.physicsWorld.gravity =  CGVectorMake(0.0,0.0);
    self.physicsWorld.contactDelegate = self;

    SKNode *leftEdge = [SKNode alloc]init];
    leftEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointZero toPoint:CGPointMake(0.0,self.size.height)];
    leftEdge.position = CGPointZero;
    leftEdge.physicsBody.categoryBitMask = kCCEdgeCategory;
    [self addChild:leftEdge];

    SKNode *rightEdge = [SKNode alloc]init];
    rightEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointZero toPoint:CGPointMake(0.0,self.size.height)];
    rightEdge.position = CGPointMake(self.size.width,0.0);
    rightEdge.physicsBody.categoryBitMask = kCCEdgeCategory;
    [self addChild:rightEdge];

    SKNode *topEdge = [SKNode alloc]init];
    topEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointZero toPoint:CGPointMake(self.size.width,0.0)];
    topEdge.position = CGPointMake(0.0,self.size.height-_topBarLayer.size.height);
    topEdge.physicsBody.categoryBitMask = kCCEdgeCategory;
    [self addChild:topEdge];

    _topBarLayer = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(self.size.width, 30)];
    _topBarLayer.position = CGPointMake(self.size.width/2, self.size.height-_topBarLayer.size.height/2);
    [self addChild:_topBarLayer];
    
    _paddleBlue = [SKSpriteNode spriteNodeWithImageNamed:@"paddleBlue"];
    _paddleBlue.position = CGPointMake(self.size.width/2, self.size.height/10 + _paddleBlue.size.height/2);
    [self addChild:_paddleBlue];
    
    _levelLabel = [SKLabelNode labelNodeWithFontNamed:@"Thonburi"];
    _levelLabel.fontSize = 20;
    if (_levelNumber) {
        _levelLabel.text = [NSString stringWithFormat:@"Level %i",_levelNumber];
    } else {
        _levelNumber = 1;
        _levelLabel.text = [NSString stringWithFormat:@"Level %i",_levelNumber];
    }
    _levelLabel.position = CGPointMake(-120, -10);
    [_topBarLayer addChild:_levelLabel];
    
    _heart = [SKSpriteNode spriteNodeWithImageNamed:@"fullHeart"];
    _heart.position = CGPointMake(_topBarLayer.size.width/2-90, 0);
    _heart.xScale = 0.6;
    _heart.yScale = 0.6;
    [_topBarLayer addChild:_heart];

    _ball = [SKSpriteNode spriteNodeWithImageNamed@"blueBall"];
    _ball.name = @"Ball";
    _ball.position = _paddleBlue.position;
    
    _ball.physicsBody = [SKPhysicsBody bodyWithCirleOfRadius:6.0];
    _ball.physicsBody.velocity = CGVectorMake(1.0*BALL_INITIAL_SPEED,0.0*BALL_INITIAL_SPEED);
    _ball.physicsBody.restitution = 1.0;
    _ball.physicsBody.linearDamping = 0.0;
    _ball.physicsBody.friction = 0.0;

    _ball.physicsBody.categoryBitMask = kCCBallCategory;
    _ball.physicsBody.collisionBitMask = kCCEdgeCategory | kCCBrickBlockCategory;
    _ball.physicsBody.contactTestBitMask = kCCBrickBlockCategory | kCCPowerUpCategory;
    [self addChild:_ball];
    
}
-(void)setDefaultNumbersAndBehaviour {
    
}
-(void)addGameMenuElements {
    
}
-(void)addBlocks {
    
}

-(SKSpriteNode *)blocksSwitch:(int)blockNumber {
    SKSpriteNode *block;
    switch (blockNumber) {
        case 1:
            block = [SKSpriteNode spriteNodeWithImageNamed:@"blueBrick"];
            break;
        case 2:
            block = [SKSpriteNode spriteNodeWithImageNamed:@"greenBrick"];
            break;
        case 3:
            block = [SKSpriteNode spriteNodeWithImageNamed:@"purpleBrick"];
            break;
        default:
            NSLog(@"Error in the blocksSwitch section, you have to push the right number");
            break;
    }
    return block;
}

-(void)drawBlocksBasedOnArray {
    NSArray *blocksArray = [[NSArray alloc]initWithArray:[self generateBlocksArrayBasedOnLevel:_levelNumber]];

    for (int columnIndex = 0; columnIndex < blocksArray.count; columnIndex++) {
        NSArray *baColumn = [[NSArray alloc]initWithArray:blocksArray[columnIndex]];
        for (int rowIndex = 0; rowIndex <= 3; rowIndex++) {
            int blockCode = [baColumn[rowIndex]integerValue];
            SKSpriteNode *blockSprite = [self blocksSwitch:blockCode];
            blockSprite.position = CGPointMake(blockSprite.size.width * (rowIndex+1) + (rowIndex * blockSprite.size.width/2), self.size.height-_topBarLayer.size.height-blockSprite.size.height * (columnIndex+1));
            [self addChild:blockSprite];
        }
    }
    
}
-(NSArray *)generateBlocksArrayBasedOnLevel:(int)levelNumber {
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSInteger columnsCount;
    if (levelNumber < 4) {
        columnsCount = 1 + arc4random_uniform(levelNumber);
    } else if (levelNumber > 4 && levelNumber < 10) {
        columnsCount = 3 + arc4random_uniform(levelNumber);
    } else if (levelNumber > 10) {
        columnsCount = 10;
    }
    
    for (int i=0; i<columnsCount; i++) {
        NSMutableArray *column = [[NSMutableArray alloc]init];
        for (int row=0; row < 4; row++) {
            NSInteger randomInteger = 1 + arc4random_uniform(3);
            NSNumber *brickType = [[NSNumber alloc]initWithInteger:randomInteger];
            [column addObject:brickType];
        };
        [resultArray addObject:column];
    }
    
    return resultArray;
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        // Moving paddle according to the touch moving
        CGPoint touchLocation = [touch locationInNode:self];
        if (touchLocation.x >= self.size.width - _paddleBlue.size.width*1/3) {
            _paddleBlue.position = CGPointMake(self.size.width - _paddleBlue.size.width*1/3, _paddleBlue.position.y);
        } else if (touchLocation.x <= _paddleBlue.size.width*1/3) {
            _paddleBlue.position = CGPointMake(_paddleBlue.size.width*1/3, _paddleBlue.position.y);
        } else {
            _paddleBlue.position = CGPointMake(touchLocation.x, _paddleBlue.position.y);
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
