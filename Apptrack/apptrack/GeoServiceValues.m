//
//  GeoServiceValues.m
//  AppTrack
//
//  Created by CICtourGUNE on 09/04/13.
//  Copyright (c) 2013 CICtourGUNE. All rights reserved.
//

#import "GeoServiceValues.h"

@implementation GeoServiceValues

@synthesize min_distance;
@synthesize batteryLevel;
@synthesize yFinTrack;
@synthesize mFinTrack;
@synthesize dFinTrack;
@synthesize fechaFinTrack;

+(GeoServiceValues *)geoservicevalues
{
    
    static GeoServiceValues *geo = nil;
    @synchronized(self)
    {
        if(!geo)
        {
            geo = [[GeoServiceValues alloc] init];
            
        }
        
    }
    return geo;
    
}
- (void) setValues : (float) minDistance : (int) batLevel : (int) yearFin : (int) monthFin : (int) dayFin{
    
    min_distance=minDistance;
    batteryLevel=batLevel;
    if (minDistance<0) {
        NSException *exception=[NSException exceptionWithName:@"La distancia mínima tiene que tener una valor positivo" reason:@"La distancia mínima tiene que tener una valor positivo" userInfo:nil];
        @throw exception;
    }
    if (batteryLevel>100 || batteryLevel<0) {
        NSException *exception=[NSException exceptionWithName:@"El porcentaje de la batería es incorrecto tiene que ser un número entero de 0 a 100" reason:@"El porcentaje de la batería es incorrecto tiene que ser un número entero de 0 a 100" userInfo:nil];
        @throw exception;

    }else{
        if ((batteryLevel==0) ||(batteryLevel<=15)){
            batteryLevel=15;
        }
    }
    
    if(yearFin==0 && monthFin==0 && dayFin==0){
        self.fechaFinTrack=NULL;
    }else{
        if(yearFin<0 || monthFin<0 || dayFin<0){
            NSException *exception=[NSException exceptionWithName:@"Los valores para el año ,mes y día tienen que ser positivos" reason:@"Los valores para el año ,mes y día tienen que ser positivos"userInfo:nil];
            @throw exception;

        }else{
            yFinTrack=[NSString stringWithFormat:@"%i",yearFin];
            mFinTrack=[NSString stringWithFormat:@"%i",monthFin];
            dFinTrack=[NSString stringWithFormat:@"%i",dayFin];
            NSString *f = [NSString stringWithFormat:@"%@-%@-%@",yFinTrack,mFinTrack,dFinTrack];
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [dateFormatter dateFromString:f];
            
            if (dateFromString==NULL) {
                NSString *fNoval = [NSString stringWithFormat:@"%@ %@",@"fecha no válida",f];
                
                NSException *exception=[NSException exceptionWithName:@"La fecha introducida para parar el servicio de tracking no es correcta" reason:fNoval userInfo:nil];
                @throw exception;
              
            }else{
                NSDate *today = [NSDate date] ;
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd"];
                [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                NSString *todayString = [dateFormat stringFromDate:today];
                NSDate *todayFromString = [[NSDate alloc] init];
                todayFromString = [dateFormatter dateFromString:todayString];
            
                if([dateFromString compare:todayFromString] == NSOrderedAscending ){
                    NSException *exception=[NSException exceptionWithName:@"La fecha introducida para parar el servicio de tracking no es correcta" reason:@"La fecha introducida para parar el servicio de tracking no es correcta, debe de introducir una fecha superior a la de hoy" userInfo:nil];
                    @throw exception;
                }else{
                   self.fechaFinTrack=dateFromString; 
                }
                
              
            }
        }
        
    }
    
    
    
    
}

@end

