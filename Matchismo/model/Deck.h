//
//  Deck2.h
//  Matchismo
//
//  Created by William Ho on 8/22/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

@property(strong, nonatomic) NSMutableArray *cards;

-(void)addCards:(Card*) card atTop:(BOOL)atTop;
-(Card*)drawRandomCard;
@end
