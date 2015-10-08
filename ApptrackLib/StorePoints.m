//
//  StorePoints.m
//  AppTrack
//
//  Created by CICtourGUNE on 09/04/13.
//  Copyright (c) 2013 CICtourGUNE. All rights reserved.
//

#import "StorePoints.h"
#import "GeoServiceValues.h"
#import "GlobalVariables.h"
#import "StoreParams.h"
#import "Database.h"

@implementation StorePoints
@synthesize locationManager;
@synthesize delegate;



-(id) init{
    self=[super init];
    if(self!=nil){
        self.locationManager=[[CLLocationManager alloc]init];
        self.locationManager.delegate=self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        geo=[GeoServiceValues geoservicevalues];
        
        geofecha=geo.fechaFinTrack;
        
        //min_distance es la distancia mínima para capturar la posición del usuario
        locationManager.distanceFilter= geo.min_distance;
        
        //Controlar la versión de iOS para el tracking de localización
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            //[self.locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
        }

        storeParams=[[StoreParams alloc]init];
        gvar=[GlobalVariables globalVariables];
        //Si el desarrollador ha definido un nivel de bateria
        //si llega a ese nivel el servicio se parará
        bat=[[BatteryController alloc]init];
        
        
    }
    return self;
}
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    latitud=[NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    longitud=[NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    
    NSDate *today = [NSDate date] ;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSString *dateString = [dateFormat stringFromDate:today];
    //como la fecha a comparar es de tipo NSDate hay que parsearlo
    NSDate *todaydate = [dateFormat dateFromString:dateString];
    
    //se comprueba que la fecha que ha introducido el desarrollador y el nivel de bateria para parar el servicio es igual al dia de hoy
    //si es igual a la fecha introducida o es igual o mayor se para el servicio
    // si no lo es sigue con el tracking
    int batLevel= [bat getBatteryLevel];
    if( [geofecha isEqualToDate:todaydate] || (batLevel <= geo.batteryLevel)){
        [self stopService];
        
    }else{

        latitud=[NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
        longitud=[NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    
        NSData *jsonData;
        NSDate *date = [NSDate date];
        NSString *jsonString;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:locale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *fecha = [dateFormatter stringFromDate:date];
        
        
        NSArray *keys = [NSArray arrayWithObjects:@"fecha",@"longitud", @"latitud", nil];
        NSArray *objects = [NSArray arrayWithObjects:fecha,longitud,latitud,nil];
        
        NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        
        
        if([NSJSONSerialization isValidJSONObject:jsonDictionary])
        {
            jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
            jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            
        }
        
        NSLog(@"json puntos a enviar al servidor: %@", jsonString);
        Database *db=[[Database alloc]init];
        [db createDatabaseTable];
        NSMutableArray *points=[db findPoints];
        //se comprueba que haya puntos para mandar al servidor
        if ([points count] > 0){
            [self transformInJSON:points];
        }        
       
        NSMutableArray *params=[db findParams];
        
        //se comprueba que haya parametros para mandar al servidor
        if ([params count] > 0){
            [storeParams transformInJSON:params :YES];
        }
        
        [self sendPostToServer:jsonData :NO];
    }
    
}

- (void) transformInJSON: (NSMutableArray *) points{
    
    NSMutableArray *PointDetail = [[NSMutableArray alloc] init];
    for (NSString *s in points) {
        NSArray *array = [s componentsSeparatedByString:@","];
        NSString *lon=[array objectAtIndex:0];
        NSString *lat=[array objectAtIndex:1];
        NSString *fecha=[array objectAtIndex:2];
        NSMutableDictionary *PointRows = [[NSMutableDictionary alloc] init];
        [PointRows  setValue:fecha forKey:@"fecha"];
		[PointRows setValue:lon forKey:@"longitud"];
		[PointRows setValue:lat forKey:@"latitud"];
        
		[PointDetail addObject:PointRows];
		
        
    }
    NSArray *info = [NSArray arrayWithArray:PointDetail];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info  options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"json puntos almacenados en sqlite: %@", jsonString);
    
    NSString *myString=[NSString stringWithFormat:@"%@%@%@",@"{\"puntos\":",jsonString,@"}"];
    NSData* data = [myString dataUsingEncoding:NSUTF8StringEncoding];
    
    [self sendPostToServer:data :YES];
}
- (void) sendPostToServer:(NSData *)jsonData :(BOOL)multi{
    NSURL *url;
    if (!([gvar queryParams]==NULL)) {
        if(multi){
            
            NSString *urlString=[NSString stringWithFormat:@"%@%@",@"http://dominio:80/apptrack/open/sdk/point/addmulti",[gvar queryParams]];
           
            NSLog(@"URL %@",urlString);
            url = [[NSURL alloc] initWithString:urlString];
        }else{
            
            NSString *urlString=[NSString stringWithFormat:@"%@%@",@"http://dominio:80/apptrack/open/sdk/point/add",[gvar queryParams]];
            
            NSLog(@"URL %@",urlString);
            url = [[NSURL alloc] initWithString:urlString];
        }
        
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody: jsonData];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        
        NSError *errorReturned = nil;
        NSURLResponse *theResponse =[[NSURLResponse alloc]init];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&errorReturned];
        Database *db1=[[Database alloc]init];
        NSMutableArray  *points=[db1 findPoints];
        int pointcount=[points count];
        [db1 createDatabaseTable];
        if (data==nil) {
            NSLog(@"No hay conexión para mandar datos");
            if(!multi){
                if (pointcount>3600) {
                    [db1 deletePoints];
                }
                [db1 savePointData:longitud :latitud];
            }
        }else{
            NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (result.length>6){
                NSString *r=[result substringToIndex:6];
                if ([r isEqual:@"<html>"]) {
                    NSLog(@"Error de conexion al servidor %@", result);
                    if(!multi){
                        if (pointcount>3600) {
                            [db1 deletePoints];
                        }
                        [db1 savePointData:longitud :latitud];
                    }
                }
            }else{
                
                if ([result isEqual:@"-1"]) {
                    //si es multi los datos están almacenados en la base de datos, por tanto no los volveremos a guardar porque se duplicarían los datos
                    if(!multi){
                        if (pointcount>3600) {
                            [db1 deletePoints];
                        }
                        [db1 savePointData:longitud :latitud];
                    }
                    
                    NSException *exception=[NSException exceptionWithName:@"DevToken y AppToken no válidos" reason:@"DevToken y AppToken no válidos" userInfo:nil];
                    @throw exception;
                    
                }else{
                    if(multi){
                        [db1 deletePoints];
                    }
                }
            }
        }

    }
        
}

- (void)stopService{
    [self.locationManager stopUpdatingLocation];
}
@end
