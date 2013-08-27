//
//  SetCard.m
//  Matchismo
//
//  Created by William Ho on 8/26/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "SetCard.h"

#define SetTypeSuit 1
#define SetTypeColor 2
#define SetTypeShading 3
#define SetTypeDifferentSuit 4
#define SetTypeDifferentColor 5
#define SetTypeDifferentShading 6

@implementation SetCard

@synthesize suit = _suit;

-(NSString*) suit
{
    return _suit ? _suit : @"?";
}

-(void) setSuit:(NSString *)suit
{
    if([[SetCard validSuits] containsObject:suit])
    {
        _suit = suit;
    }
}

-(void) setColor:(UIColor *)color
{
    if([[SetCard validColors] containsObject:color])
    {
        _color = color;
    }
}

-(void) setShading:(NSNumber *)shading
{
    if([[SetCard validShadings] containsObject:shading])
    {
        _shading = shading;
    }
}

+(NSArray*)validSuits
{
    return @[@"■", @"■ ■", @"■ ■ ■", @"▲", @"▲ ▲", @"▲ ▲ ▲", @"●", @"● ●", @"● ● ●"];
}

+(NSArray*)validColors
{
    return @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor]];
}

+(NSArray*)validShadings
{
    return @[@0.0, @0.2, @1.0];
}

-(NSAttributedString *)attributedContents
{
    NSString *cardString = self.suit;
    NSMutableAttributedString *cardMutableAttributedString = [[NSMutableAttributedString alloc] initWithString: cardString];
    NSDictionary *attributes = @{NSStrokeColorAttributeName: self.color, NSForegroundColorAttributeName: [self.color colorWithAlphaComponent:[self.shading floatValue]], NSStrokeWidthAttributeName: @-5};
    [cardMutableAttributedString setAttributes:attributes range:NSMakeRange(0, [self.suit length])];
    
    NSAttributedString *cardAttributedString = [cardMutableAttributedString mutableCopy];
    return cardAttributedString;
}

-(int)match:(NSArray *)otherCards
{
    int score = 0;
    
    //Among all three: suit, color and shading. Each of them is either all matched
    //or none matched.
    if(([self matchSuit:otherCards] || [self matchDifferentSuit:otherCards]) &&
       ([self matchColor:otherCards] || [self matchDifferentColor:otherCards]) &&
       ([self matchShading:otherCards] || [self matchDifferentShading:otherCards]))
        score = 1;
    
    return score;
}

-(BOOL)matchSuit:(NSArray*)otherCards
{
    return [self matchASet:SetTypeSuit withCards:otherCards];
}

-(BOOL)matchColor:(NSArray*)otherCards
{
    return [self matchASet:SetTypeColor withCards:otherCards];
}

-(BOOL)matchShading:(NSArray*)otherCards
{
    return [self matchASet:SetTypeShading withCards:otherCards];
}

-(BOOL)matchDifferentSuit:(NSArray*)otherCards
{
    return [self matchASet:SetTypeDifferentSuit withCards:otherCards];
}

-(BOOL)matchDifferentColor:(NSArray*)otherCards
{
    return [self matchASet:SetTypeDifferentColor withCards:otherCards];
}

-(BOOL)matchDifferentShading:(NSArray*)otherCards
{
    return [self matchASet:SetTypeDifferentShading withCards:otherCards];
}

-(BOOL)matchASet:(int)type withCards:(NSArray*)otherCards
{
    BOOL isMatch = NO;
    
    if([otherCards count] == 2)
    {
        id secondCard = [otherCards objectAtIndex:0];
        id thirdCard = [otherCards lastObject];
        if([secondCard isKindOfClass:[SetCard class]] && [thirdCard isKindOfClass:[SetCard class]])
        {
            SetCard *secondSetCard = (SetCard*)secondCard;
            SetCard *thirdSetCard = (SetCard*) thirdCard;
            switch (type) {
                case SetTypeSuit:
                    //Three cards have the same suit.
                    if([secondSetCard.suit isEqualToString:self.suit] && [thirdSetCard.suit isEqualToString:self.suit])
                        isMatch = YES;
                    NSLog(@"%@\n%@\n%@", self.suit, secondSetCard.suit, thirdSetCard.suit);
                    break;
                    
                case SetTypeColor:
                    //Three cards have the same color.
                    if([secondSetCard.color isEqual:self.color] && [thirdSetCard.color isEqual:self.color])
                        isMatch = YES;
                    NSLog(@"%@\n%@\n%@", self.color, secondSetCard.color, thirdSetCard.color);
                    break;
                    
                case SetTypeShading:
                    //Three cards have the same shading.
                    if([secondSetCard.shading isEqualToNumber: self.shading] && [thirdSetCard.shading isEqualToNumber: self.shading])
                        isMatch = YES;
                    NSLog(@"%@\n%@\n%@", self.shading, secondSetCard.shading, thirdSetCard.shading);
                    break;
                    
                case SetTypeDifferentSuit:
                    //Three cards have different suits.
                    if(![secondSetCard.suit isEqualToString:self.suit] && ![thirdSetCard.suit isEqualToString:self.suit] && ![secondSetCard.suit isEqualToString:thirdSetCard.suit])
                        isMatch = YES;
                    NSLog(@"differentsuit%@\n%@\n%@", self.suit, secondSetCard.suit, thirdSetCard.suit);
                    break;
                     
                case SetTypeDifferentColor:
                    //Three cards have different colors.
                    if(![secondSetCard.color isEqual:self.color] && ![thirdSetCard.color isEqual:self.color] && ![secondSetCard.color isEqual:thirdSetCard.color])
                        isMatch = YES;
                    NSLog(@"differentcolor%@\n%@\n%@", self.color, secondSetCard.color, thirdSetCard.color);
                    break;
                    
                case SetTypeDifferentShading:
                    //Three cards have different shadings.
                    if(![secondSetCard.shading isEqualToNumber: self.shading] && ![thirdSetCard.shading isEqualToNumber: self.shading] && ![secondSetCard.shading isEqualToNumber: thirdSetCard.shading])
                        isMatch = YES;
                    NSLog(@"differentshading%@\n%@\n%@", self.shading, secondSetCard.shading, thirdSetCard.shading);
                    break;
                    
                default:
                    break;
            }        
        }
    }
    return isMatch;
}

@end
