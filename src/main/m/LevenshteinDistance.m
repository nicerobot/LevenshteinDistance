//
//  Copyright 2012 nicerobot.org. All rights reserved.
//
// Based on the pseudo-code and some optimizations at
// http://en.wikipedia.org/wiki/Levenshtein_distance
//
#import "LevenshteinDistance.h"

/*
 d[i-1, j] + 1,  // a deletion
 d[i, j-1] + 1,  // an insertion
 d[i-1, j-1] + 1 // a substitution
 */
#ifdef DEBUG      
#define dprintf(format,args...) fprintf(stderr, format, ## args)
#else
#define dprintf(format,args...)
#endif

int LevenshteinDistanceN(NSString *from, NSString *to)
{
  int m = (int)[from length];
  int n = (int)[to length];
  int d[2][n];
  
  for (int i=1; i<=m; i++) {
    for (int j=1; j<=n; j++) {
      int r;
      int pi=i-1;
      int pj=j-1;
      int mi=i%2;
      int pmi=pi%2;
      int i1j1 = pi==0?pj:(pj==0?pi:d[pmi][pj]);
      unichar s = [from characterAtIndex:pi];
      unichar t = [to characterAtIndex:pj];
      int b = s == t;
      dprintf("\t%c%c(%d,%d,%d",s,t,b,pi,pj);
      if (b) {
        r = i1j1;
      } else {
        int ij1 = pj==0?i:d[mi][pj];
        int i1j = pi==0?j:d[pmi][j];
        r = MIN(i1j,MIN(ij1,i1j1)) + 1;
        dprintf(",%02d,%02d,%02d)",i1j1,ij1,i1j);
      }
      d[mi][j] = r;
      dprintf(")%02d",r);
    }
    dprintf("\n");
  }
  
  return d[m%2][n];
}

int LevenshteinDistanceM(NSString *from, NSString *to)
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
    for (int j=1; j<=n; j++) {
      int r;
      int pi=i-1;
      int pj=j-1;
      int mi=i%2+1;
      int pmi=pi%2+1;
      int i1j1 = pi==0?pj:d[pmi][pj];
      unichar s = [from characterAtIndex:pi];
      unichar t = [to characterAtIndex:pj];
      int b = s == t;
      dprintf("\t%c%c(%d,%d,%d",s,t,b,pi,pj);
      if (b) {
        r = i1j1;
      } else {
        int ij1 = pj==0?i:d[mi][pj];
        int i1j = pi==0?j:d[pmi][j];
        r = MIN(i1j,MIN(ij1,i1j1)) + 1;
        dprintf(",%02d,%02d,%02d)",i1j1,ij1,i1j);
      }
      d[mi][j] = r;
      dprintf(")%02d",r);
    }
    dprintf("\n");
  }
  
  return d[m%2+1][n];
}

int LevenshteinDistance(NSString *from, NSString *to)
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
      unichar s = [from characterAtIndex:pi];
      unichar t = [to characterAtIndex:pj];
      int b = s == t;
      dprintf("\t%c%c(%d,%d,%d",s,t,b,pi,pj);
      if (b) {
        r = i1j1;
      } else {
        int ij1 = d[i][pj];
        int i1j = d[pi][j];
        r = MIN(i1j,MIN(ij1,i1j1)) + 1;
        dprintf(",%02d,%02d,%02d)",i1j1,ij1,i1j);
      }
      d[i][j] = r;
      dprintf(")%02d",r);
    }
    dprintf("\n");
  }
  
  return d[m][n];
}

