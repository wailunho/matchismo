//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by William Ho on 8/23/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (readonly, nonatomic, strong) NSString *lastFlipResultString;
@property (readonly, nonatomic) int score;

//designated initializer
-(id)initWithCardCount:(NSUInteger)count
             usingDeck:(Deck*) deck;

-(void)flipCardAtIndex:(NSUInteger) index isTwoCardsMode: (BOOL) twoCardsMode;
-(Card*)cardAtIndex:(NSUInteger)index;



@end
