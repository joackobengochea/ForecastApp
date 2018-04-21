//
//  ViewController.h
//  ForecastApp
//
//  Created by Joaquin Bengochea on 18/4/18.
//  Copyright © 2018 Joaquin Bengochea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating>
@property (weak, nonatomic) IBOutlet UITableView *_citiesTableView;
@property (weak, nonatomic) IBOutlet UITableView *_lastCitiesTableView;


@end

