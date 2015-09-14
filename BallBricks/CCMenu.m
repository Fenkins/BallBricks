//
//  CCMenu.m
//  BallBricks
//
//  Created by Fenkins on 13/09/15.
//  Copyright (c) 2015 Fenkins. All rights reserved.
//

#import "CCMenu.h"

@implementation CCMenu {
    SKLabelNode* _menuLabel;
    SKLabelNode* _buttonLabel;
}

- (id)init
{
    self = [super init];
    if (self) {
        SKSpriteNode *menuTitleFrame = [SKSpriteNode spriteNodeWithImageNamed:@"button"];
        menuTitleFrame.position = CGPointMake(0.0, 40.0);
        menuTitleFrame.zPosition = 0.0;
        [self addChild:menuTitleFrame];
        
        SKSpriteNode *menuButtonFrame = [SKSpriteNode spriteNodeWithImageNamed:@"buttonEdged"];
        menuButtonFrame.position = CGPointMake(0.0, -40.0);
        menuButtonFrame.zPosition = 0.0;
        [self addChild:menuButtonFrame];
        
        _menuLabel = [SKLabelNode labelNodeWithFontNamed:@"DIN Alternate"];
        _menuLabel.position = CGPointMake(0.0, -5.0);
        _menuLabel.fontSize = 25;
        _menuLabel.fontColor = [UIColor purpleColor];
        // We want to bring labels upfront
        _menuLabel.zPosition = 1.0;
        [menuTitleFrame addChild:_menuLabel];
        
        _buttonLabel = [SKLabelNode labelNodeWithFontNamed:@"DIN Alternate"];
        _buttonLabel.position = CGPointMake(0.0, -5.0);
        _buttonLabel.fontSize = 25;
        _buttonLabel.fontColor = [UIColor purpleColor];
        // We want to bring labels upfront
        _buttonLabel.zPosition = 1.0;
        [menuButtonFrame addChild:_buttonLabel];
    }
    return self;
}

-(void)setMenuLabelText:(NSString *)menuLabelText {
    _menuLabelText = menuLabelText;
    _menuLabel.text = menuLabelText;
}

-(void)setButtonLabelText:(NSString *)buttonLabelText {
    _buttonLabelText = buttonLabelText;
    _buttonLabel.text = buttonLabelText;
}

@end
