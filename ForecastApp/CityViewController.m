//
//  CityViewController.m
//  ForecastApp
//
//  Created by Joaquin Bengochea on 19/4/18.
//  Copyright © 2018 Joaquin Bengochea. All rights reserved.
//

#import "CityViewController.h"


@interface CityViewController ()

@end

@implementation CityViewController{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString * apiKey = [NSString stringWithFormat:@"%@", @"f5809728cadb179823e61add7e156502"];
    NSError *error;
    NSString *url = [NSString stringWithFormat: @"https://api.openweathermap.org/data/2.5/weather?id=%d&APPID=%@", self.city.cityID, apiKey];
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url]];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    [self.cityNameLabel setText: self.city.name];
    NSDictionary* mainData = json[@"main"];
    [self.tempreatureLabel setText: [NSString stringWithFormat:@"Temperature: %.02fº", [mainData[@"temp"] floatValue]]];
    [self.pressureLabel setText: [NSString stringWithFormat:@"Pressure: %.02f hPa", [mainData[@"pressure"] floatValue]]];
    [self.humidityLabel setText: [NSString stringWithFormat:@"Humidity: %.02f", [mainData[@"humidity"] floatValue]]];
    [self.minTempLabel setText: [NSString stringWithFormat:@"Min temp: %.02fº", [mainData[@"min_temp"] floatValue]]];
    [self.maxTempLabel setText: [NSString stringWithFormat:@"Max temp: %.02fº", [mainData[@"max_temp"] floatValue]]];
    
    
    //MUST DEbug - commented due to lack of time
    /*GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.city.longitude
                                                            longitude:self.city.latitude
                                                                 zoom:6];
    self.map = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.map.myLocationEnabled = YES;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(self.city.longitude, self.city.latitude);
    marker.title = self.city.name;
    marker.snippet = self.city.country;
    marker.map = self.map;*/

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
