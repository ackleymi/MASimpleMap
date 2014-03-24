//
//  Pin.m
//  MASimpleMap
//
//  Created by Michael Ackley on 2/04/14.
//  Copyright (c) 2014 Michael Ackley. All rights reserved.
//

#import "Pin.h"


@implementation Pin

@synthesize coordinate, title, subtitle, placemark;

- (id)initWithPlacemark:(MKPlacemark *)place;

{
    
    placemark = place;
    
    return self;
}



- (id)copyWithZone:(NSZone *)zone;{
    
    return self;
}

@end
