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
@property(strong, nonatomic) UIColor *color;
@property(strong, nonatomic) NSNumber *shading;
@property (strong, nonatomic) NSAttributedString *attributedContents;
@property (nonatomic) BOOL isSelected;

+(NSArray*)validSuits;
+(NSArray*)validColors;
+(NSArray*)validShadings;

@end
