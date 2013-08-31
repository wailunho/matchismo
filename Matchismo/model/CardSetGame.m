//
//  CardSetGame.m
//  Matchismo
//
//  Created by William Ho on 8/26/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "CardSetGame.h"
#import "SetCard.h"
#import "Deck.h"

@interface CardSetGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (readwrite, nonatomic, strong) NSDictionary *lastFlipResultDictionary;
@end

@implementation CardSetGame

//socre multplier for card matching game
#define MATCH_BONUS 8
#define MISMATCH_PENALTY 4
#define FLIP_COST 1
#define STRINGKEY @"string"
#define FIRSTCARDKEY @"firstCard"
#define SECONDCARDKEY @"secondCard"
#define THIRDCARDKEY @"thirdCard"

-(NSDictionary*)convertToDictionaryFromString:(NSString*)string
                                    firstCard:(Card*)firstCard
                                   secondCard:(Card*)secondCard
                                    thirdCard:(Card*)thirdCard
{
    return @{STRINGKEY: string, FIRSTCARDKEY: firstCard, SECONDCARDKEY: secondCard, THIRDCARDKEY: thirdCard};
}

-(void)flipCardAtIndex:(NSUInteger) index
{
    Card *card = [self cardAtIndex:index];
    
    //check if card choosen and is playable
    if(card && !card.isUnplayable)
    {
        //check if card is not selected
        if(!card.isFaceUp)
        {
            //at this point, we have selected a card.
            //set the lastFlipResultString to nil so we can check if it has change during
            //matches, and if it is not, we can assign a message to it only when we are not
            //doing the matches. In other words, this is the first or the second card selected.
            self.lastFlipResultDictionary = nil;
            
            //find another card(second card) that is already selected to do the matching
            for(SetCard *secondCard in self.cards)
            {
                if(secondCard.isFaceUp && !secondCard.isUnplayable)
                {
                    //second card is selected, we need to once again find another card that is selected.
                    for(SetCard *thirdCard in self.cards)
                    {
                        
                        if(thirdCard != secondCard && thirdCard.isFaceUp && !thirdCard.isUnplayable)
                        {
                            //three cards are selected
                            //match these three card.
                            int matchScore = [card match:@[secondCard, thirdCard]];
                            //they are matched
                            if (matchScore)
                            {
                                card.unplayable = YES;
                                secondCard.unplayable = YES;
                                thirdCard.unplayable = YES;
                                self.score += matchScore * MATCH_BONUS;
                                NSString *tempString = [NSString stringWithFormat:@"Matched %@ , %@ and %@ for %d points!", card.contents, secondCard.contents, thirdCard.contents, matchScore * MATCH_BONUS];
                                self.lastFlipResultDictionary = [self convertToDictionaryFromString:tempString firstCard:card secondCard:secondCard thirdCard:thirdCard];
                            }
                            //not matched
                            else
                            {
                                card.FaceUp = YES;
                                secondCard.FaceUp = NO;
                                thirdCard.FaceUp = NO;
                                self.score -= MISMATCH_PENALTY;
                                NSString *tempString = [NSString stringWithFormat:@"%@ , %@ and %@ don't match! %d points penality!", card.contents, secondCard.contents, thirdCard.contents, MISMATCH_PENALTY];
                                self.lastFlipResultDictionary = [self convertToDictionaryFromString:tempString firstCard:card secondCard:secondCard thirdCard:thirdCard];
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
            if(!self.lastFlipResultDictionary)
            {
                NSString *tempString = [NSString stringWithFormat:@"Selected %@", card.contents];
                self.lastFlipResultDictionary = [self convertToDictionaryFromString:tempString firstCard:card secondCard:card thirdCard:card];
            }
        }
        else
        {
            NSString *tempString = [NSString stringWithFormat:@"Unselected %@", card.contents];
            self.lastFlipResultDictionary = [self convertToDictionaryFromString:tempString firstCard:card secondCard:card thirdCard:card];
        }
        card.faceUp = !card.isFaceUp;
    }
}

@end
