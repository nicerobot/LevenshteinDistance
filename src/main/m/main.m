#import "LevenshteinDistance.h"

int main (int argc, const char * argv[])
{
  if (argc <2) {
    return 1;
  }
  @autoreleasepool {
    NSString *first = [NSString stringWithUTF8String:argv[1]];
    for (int i=2; i<argc; i++) {
      NSString *to = [NSString stringWithUTF8String:argv[i]];
      printf("?1 %s\t%s\t%d\n",argv[1],argv[i],LevenshteinDistance(first,to));
      printf("?2 %s\t%s\t%d\n",argv[1],argv[i],LevenshteinDistanceN(first,to));
      printf("== %s\t%s\t%d\n\n",argv[1],argv[i],LevenshteinDistanceO(first,to));
    }
  }
  return 0;
}
