//
//  CardGame.h
//  Matchismo
//
//  Created by William Ho on 8/30/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardGame : NSObject

@property (nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *cards;

//designated initializer
-(id)initWithCardCount:(NSUInteger)count
             usingDeck:(Deck*) deck;

-(void)flipCardAtIndex:(NSUInteger) index;  //abstract
-(id)cardAtIndex:(NSUInteger)index;

@end
