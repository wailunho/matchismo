//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by William Ho on 8/22/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "PlayingCardDeck.h"
@implementation PlayingCardDeck

//initialize with 52 cards (a real deck)
-(id)init
{
    self = [super init];
    if(self)
    {
        for(NSString *suit in [PlayingCard validSuits]){
            for(NSUInteger rank = 1; rank <= [PlayingCard maxRank];rank++){
                PlayingCard * card  = [[PlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                [self addCards:card atTop:YES];
            }
        }
    }
    return self;
}
@end
