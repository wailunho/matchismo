//
//  CardGame.m
//  Matchismo
//
//  Created by William Ho on 8/30/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "CardGame.h"

@implementation CardGame

-(NSMutableArray*)cards
{
    if(!_cards)_cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(void)flipCardAtIndex:(NSUInteger) index
{
   //abstract
}

-(id)cardAtIndex:(NSUInteger)index
{
    //return the card in index.
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

-(id)initWithCardCount:(NSUInteger)count
             usingDeck:(Deck*) deck;
{
    self = [super init];
    if(self)
    {
        for(int i = 0; i < count; i++)
        {
            Card *card = [deck drawRandomCard];
            if(card)
                self.cards[i] = card;
            else
            {
                self = nil;
                break;
            }
        }
    }
    return self;
}

@end
