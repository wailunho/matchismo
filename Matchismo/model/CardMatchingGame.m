//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by William Ho on 8/23/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (readwrite, nonatomic, strong) NSString *lastFlipResultString;
@end

@implementation CardMatchingGame

//socre multplier for card matching game
#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

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

@end
