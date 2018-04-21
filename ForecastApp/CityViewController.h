//
//  CityViewController.h
//  ForecastApp
//
//  Created by Joaquin Bengochea on 19/4/18.
//  Copyright © 2018 Joaquin Bengochea. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "City.h"
//#import <GoogleMaps/GoogleMaps.h>

@interface CityViewController : UIViewController
@property (strong, nonatomic) City * city;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempreatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *minTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTempLabel;
//@property (weak, nonatomic) IBOutlet GMSMapView *map;

@end
