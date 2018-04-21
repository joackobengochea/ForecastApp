//
//  City.h
//  ForecastApp
//
//  Created by Joaquin Bengochea on 19/4/18.
//  Copyright © 2018 Joaquin Bengochea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property(nonatomic) int cityID;
@property(strong, nonatomic) NSString* name;
@property(strong, nonatomic) NSString* country;
@property(nonatomic) float longitude;
@property(nonatomic) float latitude;

- (instancetype) initWithID: (int)id name:(NSString*)name country:(NSString*)country longitude:(float)longitude latitude:(float) latitude;
- (BOOL) isEqual:(id) other;

@end
