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
@property (readwrite, nonatomic) int score;
@property (readwrite, nonatomic, strong) NSMutableAttributedString *lastFlipResultString;
@end

@implementation CardSetGame

//socre multplier for card matching game
#define MATCH_BONUS 8
#define MISMATCH_PENALTY 4
#define FLIP_COST 1

-(NSMutableArray*)cards
{
    if(!_cards)_cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(NSMutableAttributedString*)lastFlipResultString
{
    if(!_lastFlipResultString)_lastFlipResultString = [[NSMutableAttributedString alloc] init];
    return _lastFlipResultString;
}



-(void)flipCardAtIndex:(NSUInteger) index
{
    SetCard *card = [self cardAtIndex:index];
    
    //check if card choosen and is playable
    if(card && !card.isUnplayable)
    {
        //check if card is not selected
        if(!card.isSelected)
        {
            //at this point, we have selected a card.
            //set the lastFlipResultString to nil so we can check if it has change during
            //matches, and if it is not, we can assign a message to it only when we are not
            //doing the matches. In other words, this is the first or the second card selected.
            self.lastFlipResultString = nil;
            
            //find another card(second card) that is already selected to do the matching
            for(SetCard *secondCard in self.cards)
            {
                if(secondCard.isSelected && !secondCard.isUnplayable)
                {
                    //second card is selected, we need to once again find another card that is selected.
                    for(SetCard *thirdCard in self.cards)
                    {
                        
                        if(thirdCard != secondCard && thirdCard.isSelected && !thirdCard.isUnplayable)
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
                                self.lastFlipResultString = [NSString stringWithFormat:@"Matched %@, %@ and %@ for %d points!", card.attributedContents, secondCard.attributedContents, thirdCard.attributedContents, matchScore * MATCH_BONUS];
                            }
                            //not matched
                            else
                            {
                                card.isSelected = YES;
                                secondCard.isSelected = NO;
                                thirdCard.isSelected = NO;
                                self.score -= MISMATCH_PENALTY;
                                self.lastFlipResultString = [NSString stringWithFormat:@"%@, %@ and %@ don't match! 2 points penality!", card.attributedContents, secondCard.attributedContents, thirdCard.attributedContents];
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
                self.lastFlipResultString = [NSString stringWithFormat:@"Selected %@", card.attributedContents];
        }
        else
            self.lastFlipResultString = [NSString stringWithFormat:@"Unselected %@", card.attributedContents];
        card.isSelected = !card.isSelected;
    }

}


-(id)initWithCardCount:(NSUInteger)count
             usingDeck:(Deck*) deck;
{
    self = [super init];
    if(self)
    {
        for(int i = 0; i < count; i++)
        {
            SetCard *card = [deck drawRandomCard];
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

-(SetCard*)cardAtIndex:(NSUInteger)index
{
    //return the card in index.
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

@end
