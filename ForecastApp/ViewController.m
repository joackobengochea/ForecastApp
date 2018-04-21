//
//  ViewController.m
//  ForecastApp
//
//  Created by Joaquin Bengochea on 18/4/18.
//  Copyright © 2018 Joaquin Bengochea. All rights reserved.
//

#import "ViewController.h"
#import "City.h"
#import "CityViewController.h"

@interface ViewController ()

@end


@implementation ViewController
{
    NSMutableArray * cities;
    NSMutableArray * lastCities;
    NSArray * searchResults;
    UISearchController * searchController;
}
const int MAX_LAST_CITIES = 5;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //Load cities from JSON
    cities = [@[] mutableCopy];
    [self loadCitiesFromJson];
    
    //Load last cities from plist
    lastCities = [@[] mutableCopy];
    NSString *path = [self getFilePathFor:@"lastcities.plist"];
    NSArray* ids = [[NSArray alloc] initWithContentsOfFile:path];
    if(ids!=nil){
        for(int i=0; i<ids.count; i++){
            City* c = [self findCityIn: cities WithID:[ids[i] intValue]];
            if(c!=nil) [lastCities addObject: c];
        }
    }
    
    //init searchController
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    [searchController.searchBar sizeToFit];
    self._citiesTableView.tableHeaderView = searchController.searchBar;
    self.definesPresentationContext = YES;
    searchController.searchResultsUpdater = self;
    searchController.dimsBackgroundDuringPresentation = NO;
    
}

// gets the file path for plist save files
- (NSString*) getFilePathFor:(NSString*)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadCitiesFromJson{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"citylist" ofType:@"json"];
    NSError * error = nil;
    NSData * jsonData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
    NSArray * jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    for (int i=0; i<jsonArray.count; i++) {
        NSDictionary * city = jsonArray[i];
        NSDictionary * coord = city[@"coord"];
        [cities addObject: [[City alloc] initWithID: [city[@"id"] intValue] name: city[@"name"] country: city[@"country"] longitude: [coord[@"lon"] floatValue] latitude: [coord[@"lat"] floatValue] ]];
    }
    
    //sort cities alphabetically
    cities = [[cities sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        City* cityA = a;
        City* cityB = b;
        
        return [cityA.name compare:cityB.name];
    }] mutableCopy];
}


-(City*) findCityIn: (NSArray*) citiesArray WithID:(int)cityID{
    if(citiesArray.count ==0) return nil;
    City *lookupCity = [[City alloc] init];
    lookupCity.cityID = cityID;
    NSUInteger index =[citiesArray indexOfObject:lookupCity];
    if(index == NSNotFound){
        return nil;
    } else {
        City *actualCity = [citiesArray objectAtIndex:index];
        return actualCity;
    }
}

-(void) saveLastCities{
    NSMutableArray * citiesIds = [@[] mutableCopy];
    for(int i=0; i< lastCities.count; i++){
        int cityId = ((City*)lastCities[i]).cityID;
        [citiesIds addObject:[NSNumber numberWithInt:cityId]];
    }
    NSString* path = [self getFilePathFor:@"lastcities.plist"];
    [citiesIds writeToFile:path atomically:YES];
}
 

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self._citiesTableView){
        if(searchController.active){
            return [searchResults count];
        }
        return [cities count];
    } else if(tableView == self._lastCitiesTableView){
        return [lastCities count];
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self._citiesTableView){
        int index = (int)indexPath.row;
        static NSString* cellIdentifier = @"CityCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        City* curCity;
        if(searchController.active){
            curCity = searchResults[index];
        } else{
            curCity = cities[index];
        }
        cell.textLabel.text = curCity.name;
    
        return cell;
    } else if(tableView == self._lastCitiesTableView){
        int index = (int)indexPath.row;
        static NSString* cellIdentifier = @"LastCityCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        City* curCity;
        //show most recent cities first
        curCity = lastCities[[lastCities count] -(1+index)];
        cell.textLabel.text = curCity.name;
        
        return cell;

    }
    return nil;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self._lastCitiesTableView){
        [lastCities removeObjectAtIndex:[lastCities count]-(1+indexPath.row)];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self saveLastCities];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self._citiesTableView){
        City* selectedCity;
        if(searchController.active){
            selectedCity = searchResults[indexPath.row];
        } else{
            selectedCity = cities[indexPath.row];
        }
        if([self findCityIn:lastCities WithID:selectedCity.cityID] == nil){
            [lastCities addObject:selectedCity];
            if([lastCities count] >MAX_LAST_CITIES){
                [lastCities removeObjectAtIndex:0];
            }
            [self saveLastCities];
            [self._lastCitiesTableView reloadData];
        }
    } else if(tableView == self._lastCitiesTableView){
         [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showCityForecast"]){
        NSIndexPath * indexPath = [self._citiesTableView indexPathForSelectedRow];
        City* city;
        if(searchController.active){
            city = searchResults[indexPath.row];
        } else {
            city = cities[indexPath.row];
        }
        CityViewController* cvc = segue.destinationViewController;
        cvc.city = city;
    } else if([segue.identifier isEqualToString:@"showLastCityForecast"]){
        NSIndexPath * indexPath = [self._lastCitiesTableView indexPathForSelectedRow];
        City* city;
        city = lastCities[[lastCities count] - (1+indexPath.row)];
        CityViewController* cvc = segue.destinationViewController;
        cvc.city = city;
    }
}

#pragma mark - UISearchController methods

-(void) filterContextForSearchResult:(NSString*) searchText{
    if(searchText.length>0){
        NSPredicate * resultsPredicate = [NSPredicate predicateWithFormat:@"name contains[c]%@", searchText];
        searchResults =[cities filteredArrayUsingPredicate:resultsPredicate];
    } else{
        searchResults = cities;
    }
}

-(void) updateSearchResultsForSearchController:(UISearchController *)_searchController{
    [self filterContextForSearchResult:_searchController.searchBar.text];
    [self._citiesTableView reloadData];
}


@end
