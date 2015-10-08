//
//  StoreParams.h
//  AppTrack
//
//  Created by CICtourGUNE on 10/04/13.
//  Copyright (c) 2013 CICtourGUNE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParamValueObject.h"
#import "GlobalVariables.h"
/**
 * Clase que recoge los parámetros. En caso de tener conectividad envía al servidor los datos 
 * si no los almacena la base de datos local
 * @author CICtourGUNE
 */

@interface StoreParams : UIViewController{
    ParamValueObject *param;
    NSMutableArray *arrayParam;
    GlobalVariables *var;
    
}
/**
 * Método para almacenar los valores de una parámetro tipo int
 * @param idVariable el identificador de la variable
 * @param value el valor de esa variable
 **/
- (void) addIntParam: (int) idVariable : (int) value;
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
- (void) addDateParam: (int) idVariable : (NSString *) value;
/**
 * Método para enviar los valores de los parametros al servidor
 **/
- (void) pushParamValues;
/**
 * Método que transforma el array en un JSON
 **/
- (void) transformInJSON: (NSMutableArray *) params :(BOOL)databaseValues;

@end


