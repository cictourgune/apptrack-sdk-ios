//
//  ParamValueObject.h
//  AppTrack
//
//  Created by CICtourGUNE on 10/04/13.
//  Copyright (c) 2013 CICtourGUNE. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * Objeto identificador del parámetro y su valor
 * @author CICtourGUNE
 */

@interface ParamValueObject : NSObject{

}
@property (nonatomic, assign) int idParam;
@property (nonatomic, strong) NSString *valor;

//singleton
+(ParamValueObject *)paramvalueobject;

@end
