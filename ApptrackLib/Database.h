//
//  Database.h
//  AppTrack
//
//  Created by CICtourGUNE on 10/04/13.
//  Copyright (c) 2013 CICtourGUNE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeoServiceValues.h"
#import "sqlite3.h"

/**
 * Clase que almacena los parámetros y localización en sqlite
 * y al mismo tiempo recupera los datos almacenados en el mismo
 * @author CICtourGUNE
 */

@interface Database : UIViewController{
    
    NSString *databasePath;
    sqlite3 *PointDB;
    GeoServiceValues *geo;
}
/**
 * Método que crea la base de datos y las tablas
 */
- (void) createDatabaseTable;
/**
 * Método que almacena un punto
 */
- (void) savePointData: (NSString *)latitud :(NSString *)longitud;
/**
 * Método que borra todos los puntos
 * @param latitud latitud de la localización
 * @param longitud longitud de la localización
 */
- (void) deletePoints;
/**
 * Método que devuelve un array con todos los puntos almacenados
 * @return array con todos los puntos
 */
- (NSMutableArray*) findPoints;
/**
 * Método que almacena los valores de los parámetros
 * @param arrayp array con todos los valores de los parámetros
 */
- (void) saveParamsData: (NSMutableArray *)arrayp;
/**
 * Método que elemina todos los parámetros
 */
- (void) deleteParams;
/**
 * Método que elimina sólo un parámetro
 * @param idparam el id del parámetro a eliminar
 */
- (void) deleteIdParam: (NSString *) idparam;
/**
 * Método que devuelve todos los parámetros
 * @return devuelve un array con todos los parámetros
 */
- (NSMutableArray*) findParams;


@end
