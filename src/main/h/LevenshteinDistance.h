//
//  Created by Robert Nix on 2010.28.11.
//  Copyright 2010 nicerobot.org. All rights reserved.
//

#ifdef DEBUG      
#define dprintf(format,args...) fprintf(stderr, format, ## args)
#else
#define dprintf(format,args...)
#endif

int LevenshteinDistance(NSString *from, NSString *to);
