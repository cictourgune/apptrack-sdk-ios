//
//  GlobalVariables.h
//  AppTrack
//
//  Created by CICtourGUNE on 10/04/13.
//  Copyright (c) 2013 CICtourGUNE. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * Clase que recoge las variables globales
 * @author CICtourGUNE
 */
@interface GlobalVariables : NSObject{

}

@property (nonatomic, strong)NSString * queryParams;
//Singleton
+(GlobalVariables *)globalVariables;


@end
