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
      printf("=\t%s\t%s\t%d\n",argv[1],argv[i],LevenshteinDistance(first,to));
      printf("_\t%s\t%s\t%d\n\n",argv[1],argv[i],LevenshteinDistance1(first,to));
    }
  }
  return 0;
}
