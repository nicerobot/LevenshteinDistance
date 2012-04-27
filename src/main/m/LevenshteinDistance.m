//
//  Copyright 2012 nicerobot.org. All rights reserved.
//
// Base on pseudo-code at
// http://en.wikipedia.org/wiki/Levenshtein_distance
//
#import "LevenshteinDistance.h"

int LevenshteinDistance1(NSString *from, NSString *to)
{
  int m = (int)[from length];
  int n = (int)[to length];
  int d[m+1][n+1];
  
  for (int i=0; i<=m; i++) {
    d[i][0] = i;
  }
  for (int j=0; j<=n; j++) {
    d[0][j] = j;
  }
  
  for (int i=1; i<=m; i++) {
    for (int j=1; j<=n; j++) {
      int r;
      int pi=i-1;
      int pj=j-1;
      int i1j1 = d[pi][pj];
      int b = [from characterAtIndex:pi] == [to characterAtIndex:pj];
      printf("\t(%d",b);
      if (b) {
        r = i1j1;
      } else {
        int ij1 = d[i][pj];
        int i1j = d[pi][j];
        r = MIN(i1j,MIN(ij1,i1j1)) + 1;
        printf(",%02d,%02d",ij1,i1j);
      }
      d[i][j] = r;
      printf(")%02d",r);
    }
    printf("\n");
  }
  
  return d[m][n];
}

int LevenshteinDistance(NSString *from, NSString *to)
{
  int m = (int)[from length];
  int n = (int)[to length];
  int d[3][n+1];
  
  for (int i=0; i<3; i++) {
    d[i][0] = i;
  }
  for (int j=0; j<=n; j++) {
    d[0][j] = j;
  }
  
  for (int i=1; i<=m; i++) {
    printf("%d(%d)",i,i%2);
    for (int j=1; j<=n; j++) {
      int r;
      int pi=i-1;
      int pj=j-1;
      int mi=i%2+1;
      int pmi=pi%2+1;
      int i1j1 = pi==0?pj:d[pmi][pj];
      int b = [from characterAtIndex:pi] == [to characterAtIndex:pj];
      printf("\t(%d",b);
      if (b) {
        r = i1j1;
      } else {
        int ij1 = pj==0?i:d[mi][pj];
        int i1j = pi==0?j:d[pmi][j];
        r = MIN(i1j,MIN(ij1,i1j1)) + 1;
        printf(",%02d,%02d)",ij1,i1j);
      }
      d[mi][j] = r;
      printf(")%02d",r);
    }
    printf("\n");
  }
  
  return d[m%2+1][n];
}
