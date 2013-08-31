//
//  SetGameResult.h
//  Matchismo
//
//  Created by William Ho on 8/29/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "GameResult.h"

@interface SetGameResult : GameResult

+(NSArray*) allSetGameResults;
-(void)synchronize;

@end
