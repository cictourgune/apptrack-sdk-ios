//
//  StoreParams.m
//  AppTrack
//
//  Created by CICtourGUNE on 10/04/13.
//  Copyright (c) 2013 CICtourGUNE. All rights reserved.
//

#import "StoreParams.h"
#import "ParamValueObject.h"
#import "Database.h"
#import "GlobalVariables.h"

@interface StoreParams ()

@end

@implementation StoreParams
-(id) init{
    self=[super init];
    if(self!=nil){
        
        arrayParam = [[NSMutableArray alloc] init];
        
        
    }
    return self;
}

- (void) addIntParam: (int ) idVariable : (int ) value{
    
    ParamValueObject *paramI=[[ParamValueObject alloc]init];
    paramI.idParam=idVariable;
    NSString *numString=[NSString stringWithFormat:@"%i",value];
    paramI.valor=numString;
    [arrayParam addObject:paramI];
}
- (void) addFloatParam: (int) idVariable : (float) value{
    ParamValueObject *paramF=[[ParamValueObject alloc]init];
    paramF.idParam=idVariable;
    NSString *floatString=[NSString stringWithFormat:@"%.02f",value];
    paramF.valor=floatString;
    [arrayParam addObject:paramF];
}
- (void) addOptionParam: (int) idVariable : (NSString *) value{
    ParamValueObject *paramO=[[ParamValueObject alloc]init];
    paramO.idParam=idVariable;
    paramO.valor=value;
    [arrayParam addObject:paramO];
    
}
- (void) addDateParam: (int) idVariable : (NSString *) value{
    ParamValueObject *paramD=[[ParamValueObject alloc]init];
    paramD.idParam=idVariable;
    paramD.valor=value;
    [arrayParam addObject:paramD];
}


-(void) pushParamValues {
    
    [self transformInJSON:arrayParam :NO];
    
}
- (void) transformInJSON: (NSMutableArray *) params :(BOOL)databaseValues{
   
    NSMutableArray *ParamDetail = [[NSMutableArray alloc] init];
    if (databaseValues) {
        NSMutableDictionary *ParamRows = [[NSMutableDictionary alloc] init];
        for (NSString *s in params) {
            NSArray *array = [s componentsSeparatedByString:@","];
            NSString *idvar=[array objectAtIndex:0];
            NSString *val=[array objectAtIndex:1];
            
            [ParamRows  setValue:idvar forKey:@"idvariable"];
            [ParamRows setValue:val forKey:@"valorvariable"];;
            
            [ParamDetail addObject:ParamRows];
            
            
        }
    }else{
        for (ParamValueObject *s in params) {
            int idp=s.idParam;
            NSString *idvar=[NSString stringWithFormat:@"%i",idp];
            NSString *val=s.valor;
            NSMutableDictionary *ParamRows = [[NSMutableDictionary alloc] init];
            [ParamRows setValue:idvar forKey:@"idvariable"];
            [ParamRows setValue:val forKey:@"valorvariable"];
            
            [ParamDetail addObject:ParamRows];
            
        }
    }

    
    NSArray *info = [NSArray arrayWithArray:ParamDetail];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info  options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *myString=[NSString stringWithFormat:@"%@%@%@",@"{\"valores\":",jsonString,@"}"];
    NSLog(@"json con los valores de las variables: %@",myString);
    NSData* data = [myString dataUsingEncoding:NSUTF8StringEncoding];
    
    [self sendPostToServer:data :databaseValues];
}
- (void) sendPostToServer:(NSData *)jsonData :(BOOL)databaseValues{
    
    NSURL *url;
    
    var=[GlobalVariables globalVariables];
    NSString *query= [var queryParams];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",@"http://dominio:80/apptrack/open/sdk/value/add",query];
     
    NSLog(@"URL %@",urlString);
    url = [[NSURL alloc] initWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: jsonData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%luu",(unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    
    NSError *errorReturned = nil;
    NSURLResponse *theResponse =[[NSURLResponse alloc]init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&errorReturned];
    if (data==nil) {
        NSLog(@"No hay conexión para mandar datos");
    }else{
        NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if ((result.length>6) && ([[result substringToIndex:6] isEqual:@"<html>"])) {
            NSLog(@"error de conexion al servidor %@", result);
            
        }else{
            if ((result.length>37)){
                
             if([[result substringToIndex:37] isEqual:@"error: devToken o AppToken incorrecto"]) {
                NSException *exception=[NSException exceptionWithName:@"DevToken y AppToken no válidos" reason:@"DevToken y AppToken no válidos" userInfo:nil];
                @throw exception;
             }
               
            }else{
                if (![result isEqual:@"1"]){
                    Database *dbParam=[[Database alloc]init];
                    [dbParam createDatabaseTable];
                    NSString *resultSinEspacios=[result stringByReplacingOccurrencesOfString:@" " withString:@""];
                    NSArray *split = [resultSinEspacios componentsSeparatedByString:@";"];
                    NSString *insertados=[split objectAtIndex:0];
                    NSString *novalidos=[split objectAtIndex:1];
                    NSArray *splitInsertados;
                    NSArray *splitNoval;
                    if([insertados length]>11){
                        NSString *insSinEspacios=[insertados stringByReplacingOccurrencesOfString:@" " withString:@""];
                        NSString *insertadosNum=[insSinEspacios substringFromIndex:11];
                        
                        splitInsertados = [insertadosNum componentsSeparatedByString:@","];
                        
                    }
                    if([novalidos length]>10){
                        NSString *novalSinEspacios=[novalidos stringByReplacingOccurrencesOfString:@" " withString:@""];
                        NSString *novalNum=[novalSinEspacios substringFromIndex:10];
                        
                        splitNoval = [novalNum componentsSeparatedByString:@","];
                        
                    }
                    
                    //si devuelve error significa que no se han mandado los parametros al servidor
                    //guardaremos los datos en sqlite
                    //los datos ya anteriormente guardados en sqlite no se volverán a guardar
                    
                    BOOL noval=NO;
                    if(databaseValues==YES){
                        
                        for(int i=0;i<splitInsertados.count;i++){
                            NSString *num=[splitInsertados objectAtIndex:i];
                            [dbParam deleteIdParam:num];
                            
                        }
                        for(int i=0;i<splitNoval.count;i++){
                            NSString *num=[splitNoval objectAtIndex:i];
                            [dbParam deleteIdParam:num];
                            noval=YES;
                            
                        }
                        if(noval==YES){
                            NSString *noval=[NSString stringWithFormat:@"%@ %@",@"Los siguientes parámetros no son válidos: ",novalidos];
                            NSException *exception=[NSException exceptionWithName:@"Los siguientes parámetros no son válidos" reason:noval userInfo:nil];
                            @throw exception;
                        }
                        
                    }else{
                        
                        // Borro del arrayParam aquellos valores no válidos
                        for(int i=0;i<splitNoval.count;i++){
                            for(int j=0; j<arrayParam.count; j++){
                                ParamValueObject *obj=[arrayParam objectAtIndex:j];
                                NSString *numStringObj=[NSString stringWithFormat:@"%i",obj.idParam];
                                NSString *numStringArray=[splitNoval objectAtIndex:i];
                                if ([numStringArray isEqual:numStringObj]) {
                                    [arrayParam removeObjectAtIndex:j];
                                    noval=YES;
                                }
                                
                            }
                            
                        }
                        
                        //Borro del arrayParam aquellos valores insertados
                        for(int i=0;i<splitInsertados.count;i++){
                            for(int j=0; j<arrayParam.count; j++){
                                ParamValueObject *obj=[arrayParam objectAtIndex:j];
                                NSString *numStringObj=[NSString stringWithFormat:@"%i",obj.idParam];
                                NSString *numStringArray=[splitInsertados objectAtIndex:i];
                                if ([numStringArray isEqual:numStringObj]) {
                                    [arrayParam removeObjectAtIndex:j];
                                }
                                
                            }
                            
                        }
                        //Si hay algún parámetro que no es válido o que no se haya insertado se guardará en la base de datos de sqlite
                        NSMutableArray *ParamDetail = [[NSMutableArray alloc] init];
                        for(int i=0; i<arrayParam.count; i++){
                            ParamValueObject *obj=[arrayParam objectAtIndex:i];
                            NSString *numStringObj=[NSString stringWithFormat:@"%i",obj.idParam];
                            NSMutableDictionary *ParamRows = [[NSMutableDictionary alloc] init];
                            [ParamRows setValue:numStringObj forKey:@"idparam"];
                            [ParamRows setValue:obj.valor forKey:@"valor"];
                            [ParamDetail addObject:ParamRows];
                            
                            
                        }
                        [dbParam saveParamsData:ParamDetail];
                        [arrayParam removeAllObjects];
                        if(noval==YES){
                            NSString *noval=[NSString stringWithFormat:@"%@ %@",@"Los siguientes parámetros no son válidos: ",novalidos];
                            NSException *exception=[NSException exceptionWithName:@"Los siguientes parámetros no son válidos" reason:noval userInfo:nil];
                            @throw exception;
                            
                        }
                    }
                    
                }else{
                    [arrayParam removeAllObjects];
                }
                
            }

        }
        
                
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
