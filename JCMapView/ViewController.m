//
//  ViewController.m
//  JCMapView
//
//  Created by Student P_04 on 12/10/16.
//  Copyright © 2016 Jivan Chaudhari. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)startLocation {
    
    myLocationManager = [[CLLocationManager alloc]init];
    
    myLocationManager.delegate = self;
    
    [myLocationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [myLocationManager requestWhenInUseAuthorization];
    
    [myLocationManager startUpdatingLocation];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *currentlocation = [locations lastObject];
    
    NSLog(@"Latitude : %f",currentlocation.coordinate.latitude);
    NSString *newLatitude = [NSString stringWithFormat:@"%f",currentlocation.coordinate.latitude];
    
    _labelLatitude.text = newLatitude;
    
    NSLog(@"Longitude : %f",currentlocation.coordinate.longitude);
    NSString *newLongitude = [NSString stringWithFormat:@"%f",currentlocation.coordinate.longitude];
    _labelLongitude.text = newLongitude;
    
    NSLog(@"Speed :%f",currentlocation.speed);
    
    NSString *newSpeed = [NSString stringWithFormat:@"%f",currentlocation.speed];
    _labelSpeed .text = newSpeed;
    
    NSLog(@"Altitude :%f",currentlocation.altitude);
    NSString *newAltitude = [NSString stringWithFormat:@"%f",currentlocation.altitude];
    _labelAltitude.text = newAltitude;


    
    MKCoordinateSpan mySpan = MKCoordinateSpanMake(0.001, 0.001);
    
    MKCoordinateRegion myRegion = MKCoordinateRegionMake(currentlocation.coordinate, mySpan);
    
    
    [self.myMapView setRegion:myRegion animated:YES];
    
    
    if (currentlocation != nil) {
        [myLocationManager stopUpdatingLocation];
    }
    

    
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"%@",error.localizedDescription);
}

- (IBAction)startDectingLocationAction:(id)sender {
    
    [self startLocation];
    
    
}
@end
