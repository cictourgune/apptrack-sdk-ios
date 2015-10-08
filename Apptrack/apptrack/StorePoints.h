//
//  StorePoints.h
//  AppTrack
//
//  Created by CICtourGUNE on 09/04/13.
//  Copyright (c) 2013 CICtourGUNE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GeoServiceValues.h"
#import "StoreParams.h"
#import "GlobalVariables.h"
#import "BatteryController.h"

/**
 * Clase donde se inicializa el servicio de tracking,
 * si hay conexión se mandará la localización al servidor
 * de lo contrario se almacenará en una base de datos local.
 * @author CICtourGUNE
 */


@interface StorePoints : NSObject <CLLocationManagerDelegate>{
   
    GeoServiceValues *geo;
    StoreParams *storeParams;
    GlobalVariables *gvar;
    BatteryController *bat;
    
    NSString *latitud;
    NSString *longitud;
    NSDate *geofecha;
    
    
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) id delegate;

/**
 * Método que obtiene la localización
 * @param manager
 * @param newLocation la localización nueva
 * @param oldLocation la localización anterior
 */
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
/**
 * Método que para el servicio de tracking
 */
- (void) stopService;


@end
