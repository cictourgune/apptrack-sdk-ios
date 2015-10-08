//
//  AppTrackAPI.h
//  AppTrack
//
//  Created by CICtourGUNE on 09/04/13.
//  Copyright (c) 2013 CICtourGUNE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeoServiceValues.h"
#import "StorePoints.h"
#import "StoreParams.h"
#import "GlobalVariables.h"
#import "BatteryController.h"

/**
 * Clase principal que provee métodos importantes 
 * que hacen referencia a las demás clases
 *
 * @author CICtourGUNE
 */
@interface AppTrackAPI : UIViewController{
    
    GeoServiceValues *geo;
    StoreParams*storeParams;
    StorePoints *storepoints;
    GlobalVariables *gvar;
    BatteryController *bat;
    
    NSString *latitud;
    NSString *longitud;
    NSDate *geofecha;

}

@property (nonatomic,assign)double *distanceM;
@property (nonatomic,strong)NSString *devtoken;
@property (nonatomic,strong)NSString *apptoken;
@property (nonatomic,strong)NSString *imei;

/**
 * Método para almacenar los valores token tanto del desarrollador como de la aplicación
 * @param devToken valor del token del desarrollador
 * @param apptoken valor del token de la aplicación
 **/
- (void) setDevAppToken:(NSString *)devToken :(NSString *)appToken;
/**
 * Método para almacenar los valores de una parámetro tipo int
 * @param idVariable el identificador de la variable
 * @param value el valor de esa variable
 **/

- (void) addIntParam: (int) idVariable : (int ) value;
/**
 * Método para almacenar los valores de una parámetro tipo float
 * @param idVariable el identificador de la variable
 * @param value el valor de esa variable
 **/
- (void) addFloatParam: (int) idVariable : (float) value;
/**
 * Método para almacenar los valores de una parámetro tipo opción
 * @param idVariable el identificador de la variable
 * @param value el valor de esa variable
 **/
- (void) addOptionParam: (int) idVariable : (NSString *) value;
/**
 * Método para almacenar los valores de una parámetro tipo Date
 * @param idVariable el identificador de la variable
 * @param yearParam el valor del año
 * @param monthParam el valor del mes
 * @param dayParam el valor de día
 **/
- (void) addDateParam: (int) idVariable :(int) yearParam :(int) monthParam : (int) dayParam;
/**
 * Método para enviar los valores de los parámetros al servidor
 **/
- (void) pushParamValues;
/**
 * Método que inicializa el servicio tracking
 * @param minDistance la distancia mínima con la que se recogerá de nuevo la posición, si la distancia es igual a 0, se enviará todas las posiciones de cada movimiento 
 * @param batteryLevel nivel de batería con la que se parará el servicio de tracking, cuando la batería llegue al 15% el servicio se parará
 * @param yearF fecha (año) en la que se parará el servicio tracking, si el valor de yearF-monthF-dayF son 0, el servicio se ejecutará indefinidamente
 * @param monthF fecha (mes) en la que se parará el servicio tracking, si el valor de yearF-monthF-dayF son 0, el servicio se ejecutará indefinidamente
 * @param dayF fecha (día) en la que se parará el servicio tracking, si el valor de yearF-monthF-dayF son 0, el servicio se ejecutará indefinidamente
 **/
- (void) startTracking : (float) minDistance : (int) batteryLevel : (int) yearF : (int) monthF : (int) dayF;
/**
 * Método que finaliza el servicio tracking
 **/
- (void) stopTracking;

@end
