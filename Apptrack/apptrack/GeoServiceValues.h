//
//  GeoServiceValues.h
//  AppTrack
//
//  Created by CICtourGUNE on 09/04/13.
//  Copyright (c) 2013 CICtourGUNE. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * Objeto que recoge valores de mínima distancia, nivel de batería, año, mes y día
 *
 * @author CICtourGUNE
 */
@interface GeoServiceValues : NSObject{
 
}

@property(nonatomic, assign)float min_distance;
@property(nonatomic,assign) int batteryLevel;
@property (nonatomic,retain) NSString *yFinTrack;
@property (nonatomic,retain) NSString *mFinTrack;
@property (nonatomic,retain) NSString *dFinTrack;
@property (nonatomic, retain) NSDate *fechaFinTrack;

//Singleton
+(GeoServiceValues *)geoservicevalues;
/**
 * Método que recoge los valores: distancia mínima,nivel de batería, año, mes y día
 **/
- (void) setValues : (float) minDistance : (int) batLevel : (int) yearFin : (int) monthFin : (int) dayFin;
@end


