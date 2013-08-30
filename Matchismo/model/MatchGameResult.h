//
//  GameResult.h
//  Matchismo
//
//  Created by William Ho on 8/25/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchGameResult : NSObject

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic) int score;

+(NSArray*) allMatchGameResults;
- (id)initFromPropertyList:(id)plist;
- (id)asPropertyList;
- (NSComparisonResult)compareScoreToGameResult:(MatchGameResult *)otherResult;

@end
