//
//  ViewController.m
//  apptrack
//
//  Created by developer on 27/05/13.
//  Copyright (c) 2013 CICtourGUNE. All rights reserved.
//

#import "ViewController.h"

#import "AppTrackAPI.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	apptrackAPI=[[AppTrackAPI alloc]init];
    
    
    @try {
        [apptrackAPI setDevAppToken :@"Introducir DevToken" :@"Introducir AppToken"];
        
        //[apptrackAPI addIntParam:X :Y];
        //[apptrackAPI addFloatParam:X :Y];
        //[apptrackAPI addOptionParam:X :Y];
        //[apptrackAPI addDateParam:X :Y :Z :T];
        
        
        [apptrackAPI pushParamValues];
        [apptrackAPI startTracking:200 :26 :2015 :11 :30];
        //[apptrackAPI stopTracking];
    }
    @catch (NSException *exception) {
        NSLog(@"Excepción!! %@",exception);
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

