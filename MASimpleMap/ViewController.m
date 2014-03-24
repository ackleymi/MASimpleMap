//
//  ViewController.m
//  MASimpleMap
//
//  Created by Michael Ackley on 2/04/14.
//  Copyright (c) 2014 Michael Ackley. All rights reserved.
//

#import "ViewController.h"
#import "TableController.h"
#import "Pin.h"


@interface ViewController ()

@property (nonatomic, retain) MKMapItem *mapItem;
@property (nonatomic, strong) MKLocalSearch *localSearch;
@property (nonatomic, strong) MKLocalSearchRequest *localSearchRequest;
@property (nonatomic, strong) MKPinAnnotationView *pinSet;
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@end

@implementation ViewController
@synthesize mapItem, searchBar;

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.mapView.delegate = self;
    searchBar.delegate = self;
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setUserInteractionEnabled:YES];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
   
    
    // format the searchbar
    UITextField *txfSearchField = [searchBar valueForKey:@"_searchField"];
    [txfSearchField setBackgroundColor:[UIColor whiteColor]];
    [txfSearchField setBorderStyle:UITextBorderStyleNone];
    txfSearchField.layer.cornerRadius = 8.0f;
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [self.view addGestureRecognizer:self.tap];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self placePins];
    [self dismiss];
    
}

- (void)dismiss{
    for (UIView *tapGest in self.view.subviews) {
        if ([tapGest isKindOfClass:[UITapGestureRecognizer class]]) {
            [tapGest removeFromSuperview];
        }
    }
    [searchBar resignFirstResponder];
}

- (void)placePins{
[self.mapView removeAnnotations:self.mapView.annotations];
    self.localSearchRequest = [MKLocalSearchRequest new];
self.localSearchRequest.region = self.mapView.region;

    self.localSearchRequest.naturalLanguageQuery = self.searchBar.text;

self.localSearch = [[MKLocalSearch alloc] initWithRequest:self.localSearchRequest];
[self.localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
    
    if(error){
        
        NSLog(@"localSearch startWithCompletionHandlerFailed!  Error: %@", error);
        return;
        
    } else {
        
        self.dictionary = [NSMutableDictionary dictionary];
        
        for(mapItem in response.mapItems){
            
            
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(mapItem.placemark.location.coordinate.latitude, mapItem.placemark.location.coordinate.longitude);
            
            
            MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:coord addressDictionary:mapItem.placemark.addressDictionary];
            
            Pin *pin = [Pin new];
            pin.placemark = place;
            
            
            CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:mapItem.placemark.coordinate.latitude longitude:mapItem.placemark.coordinate.longitude];
            CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:self.mapView.userLocation.coordinate.latitude longitude:self.mapView.userLocation.coordinate.longitude];
            CLLocationDistance distance = [loc1 distanceFromLocation:loc2];
            
            NSString *descript = [NSString stringWithFormat:@"%.2f miles", distance * 0.000621371192];
            
            
            pin.placemark = place;
            pin.coordinate = coord;
            pin.title = mapItem.name;
            pin.subtitle = descript;
            [self.mapView addAnnotation:pin];
            
            [self.dictionary setObject:mapItem forKey:pin];
            
            NSArray *coordinates = [self.mapView valueForKeyPath:@"annotations.coordinate"];
            
            
            
            CLLocationCoordinate2D maxCoord = {-90.0f, -180.0f};
            
            CLLocationCoordinate2D minCoord = {90.0f, 180.0f};
            
            
            
            for(NSValue *value in coordinates) {
                
                CLLocationCoordinate2D coord = {0.0f, 0.0f};
                
                [value getValue:&coord];
                
                if(coord.longitude > maxCoord.longitude) {
                    
                    maxCoord.longitude = coord.longitude;
                    
                }
                
                if(coord.latitude > maxCoord.latitude) {
                    
                    maxCoord.latitude = coord.latitude;
                    
                }
                
                if(coord.longitude < minCoord.longitude) {
                    
                    minCoord.longitude = coord.longitude;
                    
                }
                
                if(coord.latitude < minCoord.latitude) {
                    
                    minCoord.latitude = coord.latitude;
                    
                }
                
            }
            
            MKCoordinateRegion region = {{0.0f, 0.0f}, {0.0f, 0.0f}};
            
            region.center.longitude = (minCoord.longitude + maxCoord.longitude) / 2.0;
            
            region.center.latitude = (minCoord.latitude + maxCoord.latitude) / 2.0;
            
            region.span.longitudeDelta = maxCoord.longitude - minCoord.longitude;
            
            region.span.latitudeDelta = maxCoord.latitude - minCoord.latitude;
            
            [self.mapView setRegion:region animated:NO];
        }
    }
}];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MYVC"];
    
    
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        
        return nil;
        
    }
    
    else if ([annotation isKindOfClass: [Pin class] ])
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyView"];
        
        
        
        self.pinSet = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MYPin"];
        
        self.pinSet.animatesDrop = YES;
        self.pinSet.pinColor = MKPinAnnotationColorRed;
        self.pinSet.canShowCallout = YES;
        self.pinSet.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        self.pinSet.enabled = YES;
        
        return self.pinSet;
        
    }
    
    
    return self.pinSet;
    
}



- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control

{
    MKMapItem *item = [self.dictionary objectForKey:view.annotation];
    
    TableController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"detailView"];
    /////add all the relevant information from a map point to a dictionary
    
    controller.mapDictionary = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:view.annotation.title, view.annotation.subtitle,[NSString stringWithFormat:@"%@ %@ %@ %@ %@",item.placemark.thoroughfare, item.placemark.locality, item.placemark.administrativeArea, item.placemark.            postalCode, item.placemark.country], item.phoneNumber, [NSString stringWithFormat:@"%@", item.url], item.placemark,   nil] forKeys:[NSArray arrayWithObjects:@"Name", @"Distance", @"Address", @"Phone", @"Website", @"placemark", nil]];
    
    
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
