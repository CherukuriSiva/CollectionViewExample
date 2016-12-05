//
//  AnnotaionsViewController.h
//  BR iOS Test
//
//  Created by Apple on 10/11/16.
//  Copyright © 2016 Bottle Rocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AnnotaionsViewController : UIViewController
@property (strong, nonatomic) NSArray* restaurantsArray;
@property (weak, nonatomic) IBOutlet MKMapView *mapview;
- (IBAction)backButtonTapped:(id)sender;
@end
