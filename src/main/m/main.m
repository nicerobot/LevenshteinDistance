#import "LevenshteinDistance.h"
#import "NSString+LevenshteinDistance.h"

int main (int argc, const char * argv[])
{
  if (argc <2) {
    return 1;
  }
  @autoreleasepool {
    NSString *first = [NSString stringWithUTF8String:argv[1]];
    NSMutableArray *sorted = [NSMutableArray array];
    for (int i=2; i<argc; i++) {
      NSString *to = [NSString stringWithUTF8String:argv[i]];
      [sorted addObject:to];
      printf("= %s\t%s\t%d\n",argv[1],argv[i],[[to distanceFrom:first] intValue]);
      printf("N %s\t%s\t%d\n\n",argv[1],argv[i],LevenshteinDistanceN(first,to));
    }
    NSLog(@"%@",sorted);
    [sorted sortUsingComparator:[first distanceComparator]];
    NSLog(@"%@",sorted);
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    int done = NO;
    while (!done && [loop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]]) done=YES;
  }
  return 0;
}
