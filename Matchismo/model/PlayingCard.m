//
//  PlayingCard.m
//  Matchismo
//
//  Created by William Ho on 8/22/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

+(NSArray*)validSuits
{
    return @[@"♠", @"♣", @"♥", @"♦"];
}

+(NSArray*) rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4",@"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+(NSUInteger)maxRank
{
    return [PlayingCard rankStrings].count -1;
}

-(NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString: self.suit];
}

-(NSString*) suit
{
    return _suit ? _suit : @"?";
}
-(void) setSuit:(NSString *)suit
{
    if([[PlayingCard validSuits] containsObject:suit])
    {
            _suit = suit;
    }
}

-(void) setRank:(NSUInteger)rank
{
    if(rank <= [PlayingCard maxRank])
    {
        _rank = rank;
    }
}

-(int)match:(NSArray *)otherCards
{
    int score = 0;
    //2-cards mode
    //compare the suit and rank between two cards
    //get score if suit or rank matched
    if([otherCards count] == 1)
    {
        PlayingCard *otherCard = [otherCards lastObject];
        if([otherCard.suit isEqualToString:self.suit])
        {
            score = 1;
        }
        else if(otherCard.rank == self.rank)
        {
            score = 4;
        }
    }
    //3-cards mode
    //Similar to 2-cards mode but it compares the suit and rank among all three cards
    else if([otherCards count] == 2)
    {
        PlayingCard *secondCard = [otherCards objectAtIndex:0];
        PlayingCard *thirdCard = [otherCards lastObject];
        if([secondCard.suit isEqualToString:self.suit] && [thirdCard.suit isEqualToString:self.suit])
        {
            score = 4;
        }
        else if(secondCard.rank == self.rank && thirdCard.rank == self.rank)
        {
            score = 16;
        }

    }
    return score;
}
@end
