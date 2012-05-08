//
//  NSString+LevenshteinDistance.h
//  LevenshteinDistance
//
//  Created by Robert Nix on 2012/08/05.
//  Copyright (c) 2012 Nice Robot Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LevenshteinDistance)
-(NSNumber*) distanceFrom:(NSString*)from;
-(NSNumber*) distanceTo:(NSString*)to;
-(NSComparisonResult (^)(NSString*,NSString*)) distanceComparator;
@end
