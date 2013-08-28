//
//  SetCardDeck.m
//  Matchismo
//
//  Created by William Ho on 8/26/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "SetCardDeck.h"

@implementation SetCardDeck

//initialize with 81 cards (a set deck)
-(id)init
{
    self = [super init];
    if(self)
    {
        for(NSString *suit in [SetCard validSuits]){
            for(int i = 1; i <= [SetCard maxNumOfSuits]; i++){
                for(NSString *color in [SetCard validColors]){
                    for(NSNumber *shading in [SetCard validShadings]){
                        SetCard * card  = [[SetCard alloc] init];
                        card.suit = suit;
                        card.color = color;
                        card.shading = shading;
                        card.numOfSuit = i;
                        [self addCards:card atTop:YES];
                    }
                }
            }
        }
    }
    return self;
}

@end
