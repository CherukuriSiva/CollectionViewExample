//
//  RestaurantDetailsViewController.m
//  BR iOS Test
//
//  Created by Apple on 10/11/16.
//  Copyright © 2016 Bottle Rocket. All rights reserved.
//

#import "RestaurantDetailsViewController.h"
#import "BRContact.h"
#import "BRLocation.h"
#import "AnnotaionsViewController.h"
#import "BRUtilityClass.h"

@interface RestaurantDetailsViewController ()

@end

@implementation RestaurantDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.topItem.title =@"";
    self.navigationItem.title = @"Lunch Tyme";
    [self setRestaurantLocation];
    [self setFontSizesAndText];
    
    self.navigationItem.rightBarButtonItem = [BRUtilityClass barbuttonItemWithImage:@"icon_map" Target:self action:@selector(showAnnotationsOnMapview:)];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

-(void)showAnnotationsOnMapview:(id)sender{
    
    AnnotaionsViewController *annotationsView = [self.storyboard instantiateViewControllerWithIdentifier:@"AnnotaionsViewController"];
    annotationsView.restaurantsArray = self.restaurantsArray;
    [self presentViewController:annotationsView animated:YES completion:nil];
    
}


-(void)setFontSizesAndText
{
    self.restaurantNameLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:[UIScreen mainScreen].bounds.size.height * 0.02816901408];
    self.restaurantCategoryTypeLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:[UIScreen mainScreen].bounds.size.height * 0.02112676056];
    self.restaurantAddressLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:[UIScreen mainScreen].bounds.size.height * 0.02816901408];
    self.restaurantContactNumberLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:[UIScreen mainScreen].bounds.size.height * 0.02816901408];
    self.restaurantTwitterHandleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:[UIScreen mainScreen].bounds.size.height * 0.02816901408];
   
    self.restaurantNameLabel.text = self.restaurantObj.name;
    self.restaurantCategoryTypeLabel.text = self.restaurantObj.category;
    self.restaurantAddressLabel.text = self.restaurantObj.location.formattedAddress;
    self.restaurantContactNumberLabel.text = self.restaurantObj.contact.phone;
    self.restaurantTwitterHandleLabel.text = [NSString stringWithFormat:@"@%@",self.restaurantObj.contact.twitter];
   
}

-(void)setRestaurantLocation
{
    
    self.mapview.showsUserLocation = YES;

    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = [self.restaurantObj.location.lat doubleValue];
    location.longitude = [self.restaurantObj.location.lng doubleValue];
    region.span = span;
    region.center = location;

    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
    myAnnotation.coordinate = location;
    myAnnotation.title = self.restaurantObj.name;
    [self.mapview addAnnotation:myAnnotation];

    [self.mapview setRegion:region animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
