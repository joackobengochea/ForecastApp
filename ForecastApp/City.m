//
//  City.m
//  ForecastApp
//
//  Created by Joaquin Bengochea on 19/4/18.
//  Copyright © 2018 Joaquin Bengochea. All rights reserved.
//

#import "City.h"

@implementation City

-(instancetype) initWithID: (int)cityID name:(NSString*)name country:(NSString*)country longitude:(float)longitude latitude:(float) latitude{
    self = [super init];
    if(self){
        self.cityID = cityID;
        self.name = name;
        self.country = country;
        self.longitude = longitude;
        self.latitude = latitude;
    }
    return self;
}

-(BOOL) isEqual:(id)other{
    return self.cityID == ((City*)other).cityID;
}

@end
