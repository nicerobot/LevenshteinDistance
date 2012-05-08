//
//  NSString+LevenshteinDistance.m
//  LevenshteinDistance
//
//  Created by Robert Nix on 2012/08/05.
//  Copyright (c) 2012 Nice Robot Corporation. All rights reserved.
//

#import "NSString+LevenshteinDistance.h"
#import "LevenshteinDistance.h"

@interface LevenshteinDistanceComparator : NSObject
@end

@interface LevenshteinDistanceComparator ()
@property (nonatomic,strong) NSString* reference;
@end
  
@implementation LevenshteinDistanceComparator
@synthesize reference;

-(id) initWithReference:(NSString*)source {
  self = [super init];
  self.reference = source;
  return self;
}

-(NSComparisonResult (^)(__strong NSString*,__strong NSString*)) comparator {
  __strong LevenshteinDistanceComparator *this = self;
  return ^(NSString* from, NSString *to) {
    if (from != nil && to != nil) {
      
      NSNumber *ndfrom = [this.reference distanceFrom:from];
      int ldfrom = [ndfrom intValue];

      NSNumber *ndto = [this.reference distanceFrom:to];
      int ldto = [ndto intValue];

      if (ldfrom == ldto) {
        return (NSComparisonResult) NSOrderedSame;
      } else if (ldfrom > ldto) {
        return NSOrderedDescending;
      }
      return NSOrderedAscending;
    } else if (from != nil) {
      return NSOrderedDescending;
    } else if (to != nil) {
      return NSOrderedAscending;
    }
    return NSOrderedSame;
  };
}
@end

@implementation NSString (LevenshteinDistance)

-(NSNumber*) distanceFrom:(NSString*)from {
  return [NSNumber numberWithInt:LevenshteinDistance(from,self)];
}

-(NSNumber*) distanceTo:(NSString*)to {
  return [NSNumber numberWithInt:LevenshteinDistance(self,to)];
}

-(NSComparisonResult (^)(NSString*,NSString*)) distanceComparator {
  return [[[LevenshteinDistanceComparator alloc] initWithReference:self] comparator];
}

@end
