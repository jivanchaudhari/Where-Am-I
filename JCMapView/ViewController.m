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
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handelLongPress:)];
    longPress.minimumPressDuration = 2;
    
    [self.myMapView addGestureRecognizer:longPress];
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)handelLongPress:(UIGestureRecognizer *)gesture {
    
    CLLocationCoordinate2D pressedCoordinate;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        CGPoint pressedLoction = [gesture locationInView:gesture.view];
        
        pressedCoordinate = [self.myMapView convertPoint:pressedLoction toCoordinateFromView:gesture.view];
        
        MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
        
        myAnnotation.coordinate = pressedCoordinate;
        
        CLGeocoder *geocoder = [[CLGeocoder alloc]init];
        
        CLLocation *location = [[CLLocation alloc]initWithLatitude:pressedCoordinate.latitude longitude:pressedCoordinate.longitude];
        
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            if (error) {
                
                NSLog(@"%@",error.localizedDescription);
                
                myAnnotation.title = @"Unknown Place";
                
                [self.myMapView addAnnotation:myAnnotation];

            }
            else {
                if (placemarks.count > 0) {
                    
                    CLPlacemark *myPlacemark = placemarks.lastObject;
                    
                    NSString *title = [myPlacemark.subThoroughfare stringByAppendingString:myPlacemark.thoroughfare];
                    
                    NSString *subTitle = myPlacemark.locality;
                    
                    myAnnotation .title = title;
                    
                    myAnnotation.subtitle = subTitle;
                    
                    [self.myMapView addAnnotation:myAnnotation];
                    
                }
                else {
                    myAnnotation.title = @"Unknown Place";
                    
                    [self.myMapView addAnnotation:myAnnotation];
                    
                    
                }
            }
        }];
        
    }
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        
    }
}
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"];
    annView.pinTintColor = [UIColor blueColor];
    return annView;
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

- (IBAction)changeMapType:(id)sender {
    
    localSegment = sender;
    if (localSegment.selectedSegmentIndex == 0) {
        
        [self.myMapView setMapType:MKMapTypeStandard];
    }
    else if (localSegment.selectedSegmentIndex == 1) {
        
        [self.myMapView setMapType:MKMapTypeSatellite];
    }
    else if (localSegment.selectedSegmentIndex == 2) {
        
        [self.myMapView setMapType:MKMapTypeHybrid];
    }

}

    




@end
