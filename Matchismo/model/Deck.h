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

-(void)addCards:(id) card atTop:(BOOL)atTop;
-(id)drawRandomCard;
@end
