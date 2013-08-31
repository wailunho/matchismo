//
//  GameResult.h
//  Matchismo
//
//  Created by William Ho on 8/31/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

@property (strong, nonatomic) NSDate *start;
@property (strong, nonatomic) NSDate *end;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) int score;

+(NSArray*) allGameResultsWithKey:(NSString*)key;
-(void)synchronizeWithKey:(NSString*)key;
- (NSComparisonResult)compareScoreToGameResult:(GameResult *)otherResult;

@end
