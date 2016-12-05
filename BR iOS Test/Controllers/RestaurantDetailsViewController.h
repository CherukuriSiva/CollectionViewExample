//
//  RestaurantDetailsViewController.h
//  BR iOS Test
//
//  Created by Apple on 10/11/16.
//  Copyright © 2016 Bottle Rocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRRestaurant.h"
#import <MapKit/MapKit.h>

@interface RestaurantDetailsViewController : UIViewController
@property (strong, nonatomic) BRRestaurant* restaurantObj;
@property (strong, nonatomic) NSArray* restaurantsArray;
@property (weak, nonatomic) IBOutlet MKMapView *mapview;
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantCategoryTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantContactNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantTwitterHandleLabel;
@end
