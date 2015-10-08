//
//  AppTrackAPI.m
//  AppTrack
//
//  Created by CICtourGUNE on 09/04/13.
//  Copyright (c) 2013 CICtourGUNE. All rights reserved.
//

#import "AppTrackAPI.h"
#import "GeoServiceValues.h"
#import "StorePoints.h"
#import "GlobalVariables.h"
#import "StoreParams.h"



@interface AppTrackAPI ()

@end

@implementation AppTrackAPI
@synthesize distanceM;
@synthesize devtoken;
@synthesize apptoken;
@synthesize imei;



- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(id) init{
    self=[super init];
    if(self!=nil){
        storeParams=[[StoreParams alloc]init];
        gvar=[GlobalVariables globalVariables];
        
    }
    return self;
}


-(void)setDevAppToken:(NSString *)devToken :(NSString *)appToken{
    devtoken=devToken;
    apptoken=appToken;
    if ([devToken isEqualToString:@""] || [appToken isEqualToString:@""]) {
       
        NSException *exception=[NSException exceptionWithName:@"DevToken y AppToken no pueden ser nulos" reason:@"DevToken y AppToken no pueden ser nulos" userInfo:nil];
        @throw exception;
    }else{
        NSString *ident = [[NSUserDefaults standardUserDefaults] objectForKey:@"unique identifier stored for app"];
        if (!ident) {
            CFUUIDRef uuidRef = CFUUIDCreate(NULL);
            CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
            CFRelease(uuidRef);
            ident = [NSString stringWithString:(__bridge NSString *)uuidStringRef];
            CFRelease(uuidStringRef);
            [[NSUserDefaults standardUserDefaults] setObject:ident forKey:@"unique identifier stored for app"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        imei=ident;
        
        
        NSString *myString=[NSString stringWithFormat:@"%@%@%@%@%@%@",@"?devToken=",devtoken,@"&appToken=",apptoken,@"&imei=",imei];
        [gvar setQueryParams:myString];
    }
    [self addPlatform];

    
}

- (void) addIntParam: (int ) idVariable : (int ) value{
    [storeParams addIntParam:idVariable :value ];
}
- (void) addFloatParam: (int) idVariable : (float) value{
    [storeParams addFloatParam:idVariable :value];
}
- (void) addOptionParam: (int) idVariable : (NSString *) value{
    [storeParams addOptionParam:idVariable :value];
}
- (void) addDateParam: (int) idVariable :(int) yearParam :(int) monthParam : (int) dayParam{
    NSString *y = [NSString stringWithFormat:@"%i", yearParam];
    NSString *m = [NSString stringWithFormat:@"%i", monthParam];
    NSString *d = [NSString stringWithFormat:@"%i", dayParam];
    
    NSString *dateparam=[NSString stringWithFormat:@"%@-%@-%@",y,m,d];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateparam];
    
    if (dateFromString==NULL) {
        NSException *exception=[NSException exceptionWithName:@"Formato de fecha incorrecto (addDateParam)" reason:@"Formato de fecha incorrecto (addDateParam)" userInfo:nil];
        @throw exception;
    }else{
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
        NSString *stringFromDate = [dateFormatter2 stringFromDate:dateFromString];
        [storeParams addDateParam:idVariable :stringFromDate];
    }
    
}
-(void) pushParamValues{
    [storeParams pushParamValues];
}
-(void) startTracking : (float) minDistance : (int) batteryLevel : (int) yearFin : (int) monthFin : (int) dayFin{
    if(minDistance<200.00){
        NSException *exception=[NSException exceptionWithName:@"La distancia minima tiene que ser igual o superior a 200m" reason:@"La distancia minima tiene que ser igual o superior a 200m" userInfo:nil];
        @throw exception;
    }else{
        geo =[GeoServiceValues geoservicevalues];
        [geo setValues:minDistance :batteryLevel :yearFin :monthFin :dayFin];
        
        storepoints=[[StorePoints alloc]init];
        storepoints.delegate=self;
        
        [storepoints.locationManager startUpdatingLocation];
    }
    
   
    
}
-(void) addPlatform{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",@"http://dominio:80/apptrack/open/sdk/variable/plataforma",[gvar queryParams]];
    
    NSLog(@"URL %@",urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %li", url, (long)[responseCode statusCode]);
        
    }else{
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        int idvar = [result intValue];
        [self addOptionParam:idvar :@"ios"];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void) stopTracking{
    storepoints=[[StorePoints alloc]init];
    storepoints.delegate=self;
    [storepoints stopService];
}

@end
