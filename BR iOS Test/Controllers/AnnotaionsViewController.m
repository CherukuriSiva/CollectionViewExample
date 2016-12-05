//
//  AnnotaionsViewController.m
//  BR iOS Test
//
//  Created by Apple on 10/11/16.
//  Copyright © 2016 Bottle Rocket. All rights reserved.
//

#import "AnnotaionsViewController.h"
#import "BRRestaurant.h"

@interface AnnotaionsViewController ()

@end

@implementation AnnotaionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self dispalyAnnotions];
}

-(void)dispalyAnnotions
{
    
    for (BRRestaurant *restaurantObj in self.restaurantsArray)
    {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [restaurantObj.location.lat doubleValue];
        coordinate.longitude = [restaurantObj.location.lng doubleValue];
        MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
        myAnnotation.coordinate = coordinate;
        myAnnotation.title = restaurantObj.name;
        [self.mapview addAnnotation:myAnnotation];
    
    }
    
    [self zoomToFitMapAnnotations:self.mapview];
}

- (void)zoomToFitMapAnnotations:(MKMapView *)mapView
{
    
    if ([mapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in mapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    
    // Add a little extra space on the sides
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
