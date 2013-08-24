//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by William Ho on 8/23/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (readwrite, nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *cards;
@property (readwrite, nonatomic, strong) NSString *lastFlipResultString;
@end

@implementation CardMatchingGame

-(NSMutableArray*)cards
{
    if(!_cards)_cards = [[NSMutableArray alloc] init];
    return _cards;
}

//socre multplier
#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1
//2-cards mode
-(void)flipCardAtIndex:(NSUInteger) index
{
    Card *card = [self cardAtIndex:index];
    
    if(card && !card.isUnplayable)
    {
        if(!card.isFaceUp)
        {
            for(Card *otherCard in self.cards)
            {
                if(otherCard.isFaceUp && !otherCard.isUnplayable)
                {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore)
                    {
                        card.unplayable = YES;
                        otherCard.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        self.lastFlipResultString = [NSString stringWithFormat:@"Matched %@ and %@ for %d points!", card.contents, otherCard.contents, matchScore * MATCH_BONUS];
                    }
                    else
                    {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        self.lastFlipResultString = [NSString stringWithFormat:@"%@ and %@ don't match! 2 points penality!", card.contents, otherCard.contents];
                    }
                    break;
                }
                else
                    self.lastFlipResultString = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
}

//3-cards mode
-(void)flipCardInThreeCardsModeAtIndex:(NSUInteger) index
{
    Card *card = [self cardAtIndex:index];
    
    if(card && !card.isUnplayable)
    {
        if(!card.isFaceUp)
        {
            //One card is facing up
            for(Card *secondCard in self.cards)
            {
                if(secondCard.isFaceUp && !secondCard.isUnplayable)
                {
                    //two cards are facing up
                    for(Card *thirdCard in self.cards)
                    {
                        
                        if(thirdCard != secondCard && thirdCard.isFaceUp && !thirdCard.isUnplayable)
                        {
                            //three cards are facing up
                            int matchScore = [card match:@[secondCard, thirdCard]];
                            if (matchScore)
                            {
                                card.unplayable = YES;
                                secondCard.unplayable = YES;
                                thirdCard.unplayable = YES;
                                self.score += matchScore * MATCH_BONUS;
                                self.lastFlipResultString = [NSString stringWithFormat:@"Matched %@, %@ and %@ for %d points!", card.contents, secondCard.contents, thirdCard.contents, matchScore * MATCH_BONUS];
                            }
                            else
                            {
                                secondCard.faceUp = NO;
                                thirdCard.faceUp = NO;
                                self.score -= MISMATCH_PENALTY;
                                self.lastFlipResultString = [NSString stringWithFormat:@"%@, %@ and %@ don't match! 2 points penality!", card.contents, secondCard.contents, thirdCard.contents];
                            }
                            break;
                        }
                        else
                            self.lastFlipResultString = [NSString stringWithFormat:@"Flipped up %@", card.contents];
                    }
                }
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
}

-(Card*)cardAtIndex:(NSUInteger)index
{
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
