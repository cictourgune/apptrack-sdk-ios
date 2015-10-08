//
//  BatteryController.h
//  AppTrack
//
//  Created by CICtourGUNE on 10/04/13.
//  Copyright (c) 2013 CICtourGUNE. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Clase donde se controla el nivel de batería
 * @author CICtourGUNE
 */
@interface BatteryController : UIViewController

/**
 * Método que devuelve el nivel de batería del propio dispositivo
 * @return nivel de batería del dispositivo
 */
-(int)getBatteryLevel;
@end
