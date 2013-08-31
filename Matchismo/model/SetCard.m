//
//  SetCard.m
//  Matchismo
//
//  Created by William Ho on 8/26/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "SetCard.h"

#define SetTypeSuit 1
#define SetTypeNumOfSuit 2
#define SetTypeColor 3
#define SetTypeShading 4
#define SetTypeDifferentSuit 5
#define SetTypeDifferentNumOfSuit 6
#define SetTypeDifferentColor 7
#define SetTypeDifferentShading 8

#define MaxNumberOfSuit 3
#define ShadingValueLow @0.0
#define ShadingValueMid @0.2
#define ShadingValueHigh @1.0

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

-(void) setColor:(NSString *)color
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
    return @[@"■", @"▲", @"●"];
}

+(int)maxNumOfSuits
{
    return MaxNumberOfSuit;
}

+(NSArray*)validColors
{
    return @[@"redColor", @"greenColor", @"blueColor"];
}

+(NSArray*)validShadings
{
    return @[ShadingValueLow, ShadingValueMid, ShadingValueHigh];
}

-(NSString *)contents
{
    NSMutableString *cardMutableString = [[NSMutableString alloc] initWithString:@""];
    for(int i = 1; i <= self.numOfSuit; i++)
        [cardMutableString appendString:[NSString stringWithFormat:@"%@", self.suit]];
    
    NSString *cardString = [cardMutableString copy];
    return cardString;
}

-(int)match:(NSArray *)otherCards
{
    int score = 0;
    //Among all four: suit, number of suit, color and shading. Each of them is either all matched
    //or none matched.
    if(([self matchASet:SetTypeSuit withCards:otherCards] || [self matchASet:SetTypeDifferentSuit withCards:otherCards]) &&
       ([self matchASet:SetTypeNumOfSuit withCards:otherCards] || [self matchASet:SetTypeDifferentNumOfSuit withCards:otherCards]) &&
       ([self matchASet:SetTypeColor withCards:otherCards] || [self matchASet:SetTypeDifferentColor withCards:otherCards]) &&
       ([self matchASet:SetTypeShading withCards:otherCards] || [self matchASet:SetTypeDifferentShading withCards:otherCards]))
        score = 1;
    
    return score;
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
                    break;
                    
                case SetTypeNumOfSuit:
                    //Three cards have the same number of suit.
                    if(secondSetCard.numOfSuit == self.numOfSuit && thirdSetCard.numOfSuit == self.numOfSuit)
                        isMatch = YES;
                    break;
                    
                case SetTypeColor:
                    //Three cards have the same color.
                    if([secondSetCard.color isEqualToString:self.color] && [thirdSetCard.color isEqualToString:self.color])
                        isMatch = YES;
                    break;
                    
                case SetTypeShading:
                    //Three cards have the same shading.
                    if([secondSetCard.shading isEqualToNumber: self.shading] && [thirdSetCard.shading isEqualToNumber: self.shading])
                        isMatch = YES;
                    break;
                    
                case SetTypeDifferentSuit:
                    //Three cards have different suits.
                    if(![secondSetCard.suit isEqualToString:self.suit] && ![thirdSetCard.suit isEqualToString:self.suit] && ![secondSetCard.suit isEqualToString:thirdSetCard.suit])
                        isMatch = YES;
                    break;
                    
                case SetTypeDifferentNumOfSuit:
                    //Three cards have different number of suit.
                    if(secondSetCard.numOfSuit != self.numOfSuit && thirdSetCard.numOfSuit != self.numOfSuit && secondSetCard.numOfSuit != thirdSetCard.numOfSuit)
                        isMatch = YES;
                    break;
                    
                case SetTypeDifferentColor:
                    //Three cards have different colors.
                    if(![secondSetCard.color isEqualToString:self.color] && ![thirdSetCard.color isEqualToString:self.color] && ![secondSetCard.color isEqualToString:thirdSetCard.color])
                        isMatch = YES;
                    break;
                    
                case SetTypeDifferentShading:
                    //Three cards have different shadings.
                    if(![secondSetCard.shading isEqualToNumber: self.shading] && ![thirdSetCard.shading isEqualToNumber: self.shading] && ![secondSetCard.shading isEqualToNumber: thirdSetCard.shading])
                        isMatch = YES;
                    break;
                    
                default:
                    break;
            }        
        }
    }
    return isMatch;
}

@end
