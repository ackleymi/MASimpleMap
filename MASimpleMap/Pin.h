//
//  Pin.h
//  MASimpleMap
//
//  Created by Michael Ackley on 2/04/14.
//  Copyright (c) 2014 Michael Ackley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Pin : NSObject <MKAnnotation, NSCopying>

{
    NSString *title;
    NSString *subtitle;
	CLLocationCoordinate2D coordinate;
    MKPlacemark *placemark;
    
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) MKPlacemark *placemark;


- (id)copyWithZone:(NSZone *)zone;

- (id)initWithPlacemark:(MKPlacemark *)place;




@end
