//
//  Card.m
//  Matchismo
//
//  Created by William Ho on 8/22/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "Card.h"

@implementation Card

-(BOOL)isFaceUp
{
    return _faceUp;
}

-(BOOL)isUnplayable
{
    return _unplayable;
}

-(int)match:(NSArray *)otherCards
{
    int score = 0;
    for(Card *card in otherCards)
    {
        if([card.contents isEqualToString:self.contents])
        {
            score = 1;
        }
    }
    return score;
}

@end
