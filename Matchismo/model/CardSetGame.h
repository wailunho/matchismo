//
//  CardSetGame.h
//  Matchismo
//
//  Created by William Ho on 8/26/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "SetCard.h"

@interface CardSetGame : NSObject

@property (readonly, nonatomic) int score;
@property (readonly, nonatomic, strong) NSMutableAttributedString *lastFlipResultString;

//designated initializer
-(id)initWithCardCount:(NSUInteger)count
             usingDeck:(Deck*) deck;

-(SetCard*)cardAtIndex:(NSUInteger)index;

-(void)flipCardAtIndex:(NSUInteger) index;
@end
