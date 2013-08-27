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

//socre multplier for card matching game
#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

-(NSMutableArray*)cards
{
    if(!_cards)_cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(void)flipCardAtIndex:(NSUInteger) index
{
    Card *card = [self cardAtIndex:index];

    //check if card choosen and is playable
    if(card && !card.isUnplayable)
    {
        //check if card is not facing up right before we flip it
        if(!card.isFaceUp)
        {
            //at this point, we have flip a card.
            //find another card that is already facing up to do the matching
            for(Card *otherCard in self.cards)
            {
                //the card we are finding needs to be facing up and is playable.
                if(otherCard.isFaceUp && !otherCard.isUnplayable)
                {
                    //match the card we just flipped with the card we found that is already facing up
                    int matchScore = [card match:@[otherCard]];
                    //they are matched.
                    if (matchScore)
                    {
                        card.unplayable = YES;
                        otherCard.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        self.lastFlipResultString = [NSString stringWithFormat:@"Matched %@ and %@ for %d points!", card.contents, otherCard.contents, matchScore * MATCH_BONUS];
                    }
                    //they are not matched
                    else
                    {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        self.lastFlipResultString = [NSString stringWithFormat:@"%@ and %@ don't match! 2 points penality!", card.contents, otherCard.contents];
                    }
                    break;
                }
                //no other facing up card is found, we display a message to player indicate which card has flipped
                else
                    self.lastFlipResultString = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            }
            //penality for each flip. Only when flipping it to face up.
            self.score -= FLIP_COST;
        }
        else
            self.lastFlipResultString = [NSString stringWithFormat:@"Flipped down %@", card.contents];
        //flip the face.
        card.faceUp = !card.isFaceUp;
    }
}
    /*
    //3-cards mode game control
    //similar to 2-cards mode with a little adjustment
    else
    {
        //check if card choosen and is playable
        if(card && !card.isUnplayable)
        {
            //check if card is not facing up right before we flip it
            if(!card.isFaceUp)
            {
                //at this point, we have flip a card.
                //set the lastFlipResultString to nil so we can check if it has change during
                //matches, and if it is not, we can assign a message to it only when we are not
                //doing the matches. In other words, this is the first or the second card facing up.
                self.lastFlipResultString = nil;
                
                //find another card(second card) that is already facing up to do the matching
                for(Card *secondCard in self.cards)
                {
                    if(secondCard.isFaceUp && !secondCard.isUnplayable)
                    {
                        //second card is facing up, we need to once again find another card that is facing up.
                        for(Card *thirdCard in self.cards)
                        {
                            
                            if(thirdCard != secondCard && thirdCard.isFaceUp && !thirdCard.isUnplayable)
                            {
                                //three cards are facing up
                                //match these three card.
                                int matchScore = [card match:@[secondCard, thirdCard]];
                                //they are matched
                                if (matchScore)
                                {
                                    card.unplayable = YES;
                                    secondCard.unplayable = YES;
                                    thirdCard.unplayable = YES;
                                    self.score += matchScore * MATCH_BONUS;
                                    self.lastFlipResultString = [NSString stringWithFormat:@"Matched %@, %@ and %@ for %d points!", card.contents, secondCard.contents, thirdCard.contents, matchScore * MATCH_BONUS];
                                }
                                //not matched
                                else
                                {
                                    secondCard.faceUp = NO;
                                    thirdCard.faceUp = NO;
                                    self.score -= MISMATCH_PENALTY;
                                    self.lastFlipResultString = [NSString stringWithFormat:@"%@, %@ and %@ don't match! 2 points penality!", card.contents, secondCard.contents, thirdCard.contents];
                                }
                                break;
                            }
                        }
                    }
                }
                //penality for each flip. Only when flipping it to face up.
                self.score -= FLIP_COST;
                //if we try to match, lastFlipResultString should have something in it. If not,
                //we assign a message to tell the playing which card he or she flipped.
                if(!self.lastFlipResultString)
                    self.lastFlipResultString = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            }
            card.faceUp = !card.isFaceUp;
        }
    }
     */

-(Card*)cardAtIndex:(NSUInteger)index
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
