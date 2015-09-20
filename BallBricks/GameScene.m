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
    SKSpriteNode *_menuLayer;
    SKSpriteNode *_paddleBlue;
    SKSpriteNode *_ball;
    SKLabelNode *_levelLabel;
    NSArray *livesArray;
    CCMenu *_gameMenu;
    int _levelNumber;
    BOOL isGameOver;
    BOOL isLiveLost;
    BOOL isLevelComplete;
    int _ballsCount;
//    int _destroyableBricksCount;
    SKAction *_ballBounceSound;
    SKAction *_brickSmashSound;
    SKAction *_levelUpSound;
    SKAction *_loseLifeSound;
    SKAction *_paddleBounce;
}
static const CGFloat BALL_INITIAL_SPEED     = 400.0f;

static const uint32_t kCCBallCategory           = 0x1 << 0;
static const uint32_t kCCPowerUpCategory        = 0x1 << 1;
static const uint32_t kCCEdgeCategory           = 0x1 << 2;
static const uint32_t kCCBlueBrickCategory      = 0x1 << 3;
static const uint32_t kCCGreenBrickCategory     = 0x1 << 4;
static const uint32_t kCCPurpleBrickCategory    = 0x1 << 5;
static const uint32_t kCCPaddleCategory         = 0x1 << 6;

-(void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor whiteColor];
    [self addDefaultSceneElements];
    [self drawBlocksBasedOnArray];
}

-(void)addDefaultSceneElements {
    self.physicsWorld.gravity =  CGVectorMake(0.0,0.0);
    self.physicsWorld.contactDelegate = self;

    SKNode *leftEdge = [[SKNode alloc]init];
    leftEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointZero toPoint:CGPointMake(0.0,self.size.height)];
    leftEdge.position = CGPointZero;
    leftEdge.physicsBody.categoryBitMask = kCCEdgeCategory;
    [self addChild:leftEdge];

    SKNode *rightEdge = [[SKNode alloc]init];
    rightEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointZero toPoint:CGPointMake(0.0,self.size.height)];
    rightEdge.position = CGPointMake(self.size.width,0.0);
    rightEdge.physicsBody.categoryBitMask = kCCEdgeCategory;
    [self addChild:rightEdge];

    SKNode *topEdge = [[SKNode alloc]init];
    topEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointZero toPoint:CGPointMake(self.size.width,0.0)];
    topEdge.position = CGPointMake(0.0,self.size.height-_topBarLayer.size.height);
    topEdge.physicsBody.categoryBitMask = kCCEdgeCategory;
    [self addChild:topEdge];

    _topBarLayer = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(self.size.width, 30)];
    _topBarLayer.position = CGPointMake(self.size.width/2, self.size.height-_topBarLayer.size.height/2);
    [self addChild:_topBarLayer];
    
    _paddleBlue = [SKSpriteNode spriteNodeWithImageNamed:@"paddleBlue"];
    _paddleBlue.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(_paddleBlue.size.width,_paddleBlue.size.height)];
    _paddleBlue.physicsBody.dynamic = NO;
    _paddleBlue.physicsBody.categoryBitMask = kCCPaddleCategory;
    _paddleBlue.physicsBody.linearDamping = 0.0;
    _paddleBlue.physicsBody.collisionBitMask = kCCBallCategory;
    _paddleBlue.physicsBody.contactTestBitMask = kCCBallCategory;
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

    // Adding menu layer
    _menuLayer = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(self.size.width, self.size.height)];
    _menuLayer.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:_menuLayer];

    // Initializing game menu
    _gameMenu = [[CCMenu alloc]init];
    [_menuLayer addChild:_gameMenu];
    
    livesArray = [self restoreAllLives];
    [self drawLiveBar:livesArray];
    
    [self bringBallToPlatform];
    _ballsCount = 1;
    
    _menuLayer.hidden = YES;
    isLiveLost = NO;
    isGameOver = NO;
    isLevelComplete = NO;
    
    (isLiveLost) ? [self runAction:_ballBounceSound] : [self runAction:_ballBounceSound];
    
    // Sounds
    _ballBounceSound = [SKAction playSoundFileNamed:@"BallBounce.caf" waitForCompletion:NO];
    _brickSmashSound = [SKAction playSoundFileNamed:@"BrickSmash.caf" waitForCompletion:NO];
    _levelUpSound = [SKAction playSoundFileNamed:@"LevelUp.caf" waitForCompletion:NO];
    _loseLifeSound = [SKAction playSoundFileNamed:@"LoseLife.caf" waitForCompletion:NO];
    _paddleBounce = [SKAction playSoundFileNamed:@"PaddleBounce.caf" waitForCompletion:NO];
}

-(void)bringBallToPlatform {
    _ball = [SKSpriteNode spriteNodeWithImageNamed:@"blueBall"];
    _ball.name = @"Ball";
    _ball.xScale = 1.3;
    _ball.yScale = 1.3;
    _ball.position = CGPointMake(_paddleBlue.position.x, _paddleBlue.position.y+_ball.size.height);
    
    _ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:6.0];
    _ball.physicsBody.dynamic = YES;
    _ball.physicsBody.velocity = CGVectorMake(0.0*BALL_INITIAL_SPEED,1.0*BALL_INITIAL_SPEED);
    _ball.physicsBody.restitution = 1.0;
    _ball.physicsBody.linearDamping = 0.0;
    _ball.physicsBody.friction = 0.0;
    
    _ball.physicsBody.categoryBitMask = kCCBallCategory;
    _ball.physicsBody.collisionBitMask = kCCEdgeCategory | kCCPaddleCategory | kCCBlueBrickCategory | kCCGreenBrickCategory | kCCPurpleBrickCategory;
    _ball.physicsBody.contactTestBitMask = kCCBlueBrickCategory | kCCGreenBrickCategory | kCCPurpleBrickCategory | kCCPowerUpCategory | kCCPaddleCategory;
    [self addChild:_ball];
    _ballsCount++;
    isLiveLost = NO;
}

-(void)removeHeartsFromScene {
    // Enumerating heart nodes and removing them from the scene
    [_topBarLayer enumerateChildNodesWithName:@"Heart" usingBlock:^(SKNode *node, BOOL *stop) {
            [node removeFromParent];
    }];
}

-(void)drawLiveBar:(NSArray*)lives {
    for (int i = 0; i<lives.count; i++) {
        SKSpriteNode *heart = [SKSpriteNode spriteNodeWithImageNamed:@"fullHeart"];
        heart.name = @"Heart";
        heart.position = CGPointMake(_topBarLayer.size.width/2-90+heart.size.width/2*i, 1);
        heart.xScale = 0.6;
        heart.yScale = 0.6;
        [_topBarLayer addChild:heart];
    }
}

-(NSArray *)restoreAllLives {
    NSArray *fullArray = @[@0,@0,@0];
    return fullArray;
}

-(NSArray *)removeOneLive:(NSArray*)lives {
    NSArray *resultArray;
    if (lives) {
        NSMutableArray *livesiSChanging = [[NSMutableArray alloc]initWithArray:lives];
        int livesCount = [lives count];
        [livesiSChanging removeObjectAtIndex:livesCount-1];
        resultArray = [livesiSChanging copy];
    } else {
        NSLog(@"Terrible trouble with array, that you are putting in here");
    }
    return resultArray;
}

-(CCBrick *)blocksSwitch:(int)blockNumber {
    CCBrick *block;
    switch (blockNumber) {
        case 1:
            block = [[CCBrick alloc]initWithImageNamed:@"blueBrick"];
            block.name = @"blueBrick";
            break;
        case 2:
            block = [[CCBrick alloc] initWithImageNamed:@"greenBrick"];
            block.name = @"greenBrick";
            break;
        case 3:
            block = [[CCBrick alloc] initWithImageNamed:@"purpleBrick"];
            block.name = @"purpleBrick";
            break;
        default:
            NSLog(@"Error in the blocksSwitch section, you have to push the right number");
            break;
    }
    return block;
}


-(NSArray *)generateBlocksArrayBasedOnLevel:(int)levelNumber {
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSInteger columnsCount;
    if (levelNumber < 4) {
        columnsCount = 1 + arc4random_uniform(levelNumber);
    } else if (levelNumber >= 4 && levelNumber < 10) {
        columnsCount = 3 + arc4random_uniform(levelNumber);
    } else if (levelNumber >= 10) {
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


-(void)drawBlocksBasedOnArray {
    [self blocksCleaner];
    NSArray *blocksArray = [[NSArray alloc]initWithArray:[self generateBlocksArrayBasedOnLevel:_levelNumber]];
//    NSLog(@"ARR %@",blocksArray);

    for (int columnIndex = 0; columnIndex < blocksArray.count; columnIndex++) {
        NSArray *baColumn = [[NSArray alloc]initWithArray:blocksArray[columnIndex]];
        for (int rowIndex = 0; rowIndex <= 3; rowIndex++) {
            int blockCode = [baColumn[rowIndex]integerValue];
            
            CCBrick *blockSprite = [self blocksSwitch:blockCode];
            blockSprite.position = CGPointMake(blockSprite.size.width * (rowIndex+1) + (rowIndex * blockSprite.size.width/2), self.size.height-_topBarLayer.size.height+blockSprite.size.height-(blockSprite.size.height * (columnIndex+1))*2);
            blockSprite.zPosition = -0.5;
            [self addChild:blockSprite];
        }
    }
    
}

-(void)blocksCleaner {
    // Erasing green blocks from view(if any)
    [self enumerateChildNodesWithName:@"greenBrick" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    // Erasing blue blocks from view(if any)
    [self enumerateChildNodesWithName:@"blueBrick" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    // Erasing purple blocks from view(if any)
    [self enumerateChildNodesWithName:@"purpleBrick" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
}


-(void)didBeginContact:(SKPhysicsContact *)contact {
    if ([contact.bodyA.node isKindOfClass:[CCBrick class]] || [contact.bodyB.node isKindOfClass:[CCBrick class]]) {

        CCBrick *firstBody;
        SKPhysicsBody *secondBody;
        
        if (contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask) {
            firstBody = (CCBrick*)contact.bodyA.node;
            secondBody = contact.bodyB;
        } else {
            firstBody = (CCBrick*)contact.bodyB.node;
            secondBody = contact.bodyA;
        }
        
        // Detecting contacts with BLUE bricks here
        if (firstBody.physicsBody.categoryBitMask == kCCBlueBrickCategory && secondBody.categoryBitMask == kCCBallCategory) {
            [self addExplosion:firstBody.position withName:@"brickExplosion"];
            firstBody.name = nil;
            [firstBody removeFromParent];
            [self runAction:_brickSmashSound];
            if (![self childNodeWithName:@"blueBrick"] && ![self childNodeWithName:@"greenBrick"]) {
                [self nextLevelPopup];
            }
        }
        // Detecting contacts with GREEN bricks here
        if (firstBody.physicsBody.categoryBitMask == kCCGreenBrickCategory && secondBody.categoryBitMask == kCCBallCategory) {
            if (firstBody.hitCounter >= 1) {
                [self addExplosion:firstBody.position withName:@"brickExplosion"];
                firstBody.name = nil;
                [firstBody removeFromParent];
                [self runAction:_brickSmashSound];
                if (![self childNodeWithName:@"greenBrick"] && ![self childNodeWithName:@"blueBrick"]) {
                    [self nextLevelPopup];
                }
            } else if (firstBody.hitCounter >= 0) {
                firstBody.hitCounter++;
                [self runAction:_brickSmashSound];
            }
        }
        // Detecting contacts with PURPLE bricks here
        if (firstBody.physicsBody.categoryBitMask == kCCPurpleBrickCategory && secondBody.categoryBitMask == kCCBallCategory) {
            [self runAction:_ballBounceSound];
        }
        
    } else {
        SKPhysicsBody *firstBody;
        SKPhysicsBody *secondBody;
        
        if (contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask) {
            firstBody = contact.bodyA;
            secondBody = contact.bodyB;
        } else {
            firstBody = contact.bodyB;
            secondBody = contact.bodyA;
        }

        // Detecting all other contacts here
        if (firstBody.categoryBitMask == kCCPaddleCategory && secondBody.categoryBitMask == kCCBallCategory) {
            
            [self runAction:_ballBounceSound];
            
            // Adding ball shifting sector to the paddle (right edge)
            [self enumerateChildNodesWithName:@"Ball" usingBlock:^(SKNode *node, BOOL *stop) {
                if (CGRectContainsPoint(CGRectMake(_paddleBlue.position.x+_paddleBlue.size.width/4+_paddleBlue.size.width/16, _paddleBlue.position.y, _paddleBlue.size.width/4, _paddleBlue.size.height), node.position)) {
                    _ball.physicsBody.velocity = CGVectorMake(_ball.physicsBody.velocity.dx+150.0, _ball.physicsBody.velocity.dy);
                    [self normalize];
                }
            }];
            // Adding ball shifting sector to the paddle (right middle)
            [self enumerateChildNodesWithName:@"Ball" usingBlock:^(SKNode *node, BOOL *stop) {
                if (CGRectContainsPoint(CGRectMake(_paddleBlue.position.x+_paddleBlue.size.width/16, _paddleBlue.position.y, _paddleBlue.size.width/4, _paddleBlue.size.height), node.position)) {
                    _ball.physicsBody.velocity = CGVectorMake(_ball.physicsBody.velocity.dx+100, _ball.physicsBody.velocity.dy);
                    [self normalize];
                }
            }];
            // Adding ball shifting sector to the paddle (left middle)
            [self enumerateChildNodesWithName:@"Ball" usingBlock:^(SKNode *node, BOOL *stop) {
                if (CGRectContainsPoint(CGRectMake(_paddleBlue.position.x-_paddleBlue.size.width/16-_paddleBlue.size.width/4, _paddleBlue.position.y, _paddleBlue.size.width/4, _paddleBlue.size.height), node.position)) {
                    _ball.physicsBody.velocity = CGVectorMake(_ball.physicsBody.velocity.dx-100, _ball.physicsBody.velocity.dy);
                    [self normalize];
                }
            }];
            // Adding ball shifting sector to the paddle (left edge)
            [self enumerateChildNodesWithName:@"Ball" usingBlock:^(SKNode *node, BOOL *stop) {
                if (CGRectContainsPoint(CGRectMake(_paddleBlue.position.x-_paddleBlue.size.width/4-_paddleBlue.size.width/16-_paddleBlue.size.width/4, _paddleBlue.position.y, _paddleBlue.size.width/4, _paddleBlue.size.height), node.position)) {
                    _ball.physicsBody.velocity = CGVectorMake(_ball.physicsBody.velocity.dx-150, _ball.physicsBody.velocity.dy);
                    [self normalize];
                }
            }];
        }
    }
}


-(void)normalize {
    // This code is probably is a full trigonometrical crap, since I am not really good at it
    // Just trying to stabilize the ball velocity so it won't bounce around like it is on some freakin cocaine or something
    CGFloat resultVector = sqrt(_ball.physicsBody.velocity.dx*_ball.physicsBody.velocity.dx + _ball.physicsBody.velocity.dy*_ball.physicsBody.velocity.dy);
    NSLog(@"Your result vec %f",resultVector);
    if (resultVector != BALL_INITIAL_SPEED) {
        NSLog(@"x and y %f,%f",_ball.physicsBody.velocity.dx, _ball.physicsBody.velocity.dy);
        CGFloat vecSum = sqrt(_ball.physicsBody.velocity.dx*_ball.physicsBody.velocity.dx) + sqrt(_ball.physicsBody.velocity.dy*_ball.physicsBody.velocity.dy);
        CGFloat xMult = _ball.physicsBody.velocity.dx / vecSum;
        NSLog(@"xMult %f",xMult);
        CGFloat yMult = _ball.physicsBody.velocity.dy / vecSum;
        NSLog(@"yMult %f",yMult);
        _ball.physicsBody.velocity = CGVectorMake(xMult*BALL_INITIAL_SPEED*1.25, yMult*BALL_INITIAL_SPEED*1.25);
    }
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

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch* touch in touches) {
        if (isGameOver) {
            SKNode *n = [_gameMenu nodeAtPoint:[touch locationInNode:_gameMenu]];
            if ([n.name isEqualToString:@"Menu_Button"]) {
                [self restartGame];
            }
        }
        if (isLevelComplete) {
            SKNode *n = [_gameMenu nodeAtPoint:[touch locationInNode:_gameMenu]];
            if ([n.name isEqualToString:@"Menu_Button"]) {
                [self nextLevelProceed];
            }
        }
    }
}

-(void)gameOver {
    if (!isGameOver) {
        isGameOver = YES;
        [self removeHeartsFromScene];
        _gameMenu.menuLabelText = @"Game Over";
        _gameMenu.buttonLabelText = @"Retry";
        _menuLayer.hidden = NO;
    }
}
-(void)restartGame {
    isGameOver = NO;
    _menuLayer.hidden = YES;
    livesArray = [self restoreAllLives];
    [self drawLiveBar:livesArray];
    [self bringBallToPlatform];
    [self drawBlocksBasedOnArray];
}
-(void)nextLevelPopup {
    [self enumerateChildNodesWithName:@"Ball" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    _ballsCount = 0;
    _gameMenu.menuLabelText = [NSString stringWithFormat:@"Level %d complete!",_levelNumber];
    _gameMenu.buttonLabelText = @"Next Level";
    _menuLayer.hidden = NO;
    isLevelComplete = YES;
    NSLog(@"You have %d balls",_ballsCount);
}

-(void)nextLevelProceed {
    _menuLayer.hidden = YES;
    _levelNumber++;
    [self drawBlocksBasedOnArray];
    [self bringBallToPlatform];
    isLevelComplete = NO;
    _levelLabel.text = [NSString stringWithFormat:@"Level %d",_levelNumber];
    NSLog(@"You have %d balls",_ballsCount);
}

-(void)didSimulatePhysics {
    // Removing unused nodes
    [self enumerateChildNodesWithName:@"Ball" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y + node.frame.size.height < 0) {
            [node removeFromParent];
            _ballsCount--;
        }
    }];
    if (_ballsCount == 0 && livesArray.count == 1 && !isLevelComplete) {
        // We don't have lives left and we lost the ball
        [self gameOver];

    } else if (_ballsCount == 0 && !isLevelComplete) {
        // If there is no more balls on the screen,
        // we want to remove one live and bring atleast one ball back
        isLiveLost = YES;
        livesArray = [self removeOneLive:livesArray];
        [self removeHeartsFromScene];
        [self drawLiveBar:livesArray];
        [self bringBallToPlatform];
    }
    
    
}

-(void)addExplosion:(CGPoint)position withName:(NSString*) name {
    NSString *explosionPath = [[NSBundle mainBundle]pathForResource:name ofType:@"sks"];
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
    explosion.position = position;
    [self addChild:explosion];
    SKAction *removeExplosion = [SKAction sequence:@[[SKAction waitForDuration:1.5],
                                                     [SKAction removeFromParent]]];
    [self runAction:removeExplosion];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}


@end
