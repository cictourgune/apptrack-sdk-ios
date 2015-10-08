//
//  ParamValueObject.m
//  AppTrack
//
//  Created by CICtourGUNE on 10/04/13.
//  Copyright (c) 2013 CICtourGUNE. All rights reserved.
//

#import "ParamValueObject.h"

@implementation ParamValueObject

@synthesize idParam;
@synthesize valor;

+(ParamValueObject *)paramvalueobject
{
    
    static ParamValueObject *param = nil;
    @synchronized(self)
    {
        if(!param)
        {
            param = [[ParamValueObject alloc] init];
            
        }
        
    }
    return param;
    
}


@end
