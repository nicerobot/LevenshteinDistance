//
//  Copyright 2012 nicerobot.org. All rights reserved.
//
// Based on the pseudo-code and some optimizations at
// http://en.wikipedia.org/wiki/Levenshtein_distance
//

#import "LevenshteinDistance.h"

int LevenshteinDistanceN(NSString *from, NSString *to)
{
  int m = (int)[from length];
  int n = (int)[to length];
  int d[2][n];
  
  for (int i=0; i<m; i++) {
    for (int j=0; j<n; j++) {
      int r;
      int pi=i%2+1;

      int i1j1 = i==0?j:(j==0?i:d[i][j]);
      unichar s = [from characterAtIndex:i];
      unichar t = [to characterAtIndex:j];
      int b = s == t;
      dprintf("\t%c%c( %c %2d %2d",s,t,b?'t':'f',i,j);
      if (b) {
        r = i1j1;
      } else {
        int ij1 = j==0?i+1:d[pi][j];
        int i1j = i==0?j+1:(j==0?i:d[i][j-1]);
        r = MIN(i1j,MIN(ij1,i1j1)) + 1;
        dprintf(" , %2d %2d %2d",i1j1,ij1,i1j);
      }
      d[i][j] = r;
      dprintf(" ) %2d",r);
    }
    dprintf("\n");
  }
  
  dprintf("%d,%d=",m%2+1,n-1);
  return d[m%2+1][n-1];
}

