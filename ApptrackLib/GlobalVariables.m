//
//  GlobalVariables.m
//  AppTrack
//
//  Created by CICtourGUNE on 10/04/13.
//  Copyright (c) 2013 CICtourGUNE. All rights reserved.
//

#import "GlobalVariables.h"

@implementation GlobalVariables
@synthesize queryParams;

+(GlobalVariables *)globalVariables
{
    
    static GlobalVariables *var = nil;
    @synchronized(self)
    {
        if(!var)
        {
            var = [[GlobalVariables alloc] init];
            
        }
    }
    return var;
    
}

@end
