//
//  BatteryController.m
//  AppTrack
//
//  Created by CICtourGUNE on 10/04/13.
//  Copyright (c) 2013 CICtourGUNE. All rights reserved.
//

#import "BatteryController.h"

@interface BatteryController ()

@end

@implementation BatteryController



- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

-(int)getBatteryLevel{
    UIDevice *myDevice = [UIDevice currentDevice];
    
    NSString *model=[[UIDevice currentDevice] model];
    [myDevice setBatteryMonitoringEnabled:YES];
    float batLeft = [myDevice batteryLevel];
    int batinfo;

    if ([model isEqualToString:@"iPhone Simulator"]) {
        batinfo=100;
    }else{
        batinfo=(batLeft*100);
    }

    return batinfo;
}

-(void)batteryLevel {
    // obtain the battery details
    CGFloat value = [[UIDevice currentDevice] batteryLevel];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
