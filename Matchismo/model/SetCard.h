//
//  SetCard.h
//  Matchismo
//
//  Created by William Ho on 8/26/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property(strong, nonatomic) NSString *suit;
@property(nonatomic) int numOfSuit;
@property(strong, nonatomic) NSString *color;
@property(strong, nonatomic) NSNumber *shading;

+(NSArray*)validSuits;
+(NSArray*)validColors;
+(NSArray*)validShadings;
+(int)maxNumOfSuits;

@end
