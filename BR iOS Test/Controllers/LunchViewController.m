//
//  LunchViewController.m
//  BR iOS Test
//
//  Created by Apple on 09/11/16.
//  Copyright © 2016 Bottle Rocket. All rights reserved.
//

#import "LunchViewController.h"
#import "BRRestaurant.h"
#import "BRUtilityClass.h"
#import "RestaurantDetailsViewController.h"
#import "AnnotaionsViewController.h"

#define KSERVERENDPOINT @"http://sandbox.bottlerocketapps.com/BR_iOS_CodingExam_2015_Server/restaurants.json"
#define heightCalculate(h) (([[UIScreen mainScreen] bounds].size.height) * (h / 568.0))

@interface LunchViewController ()
@property (nonatomic, strong) NSMutableArray *restuarantsArray;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation LunchViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getRestaurantData];
    
    self.navigationItem.rightBarButtonItem = [BRUtilityClass barbuttonItemWithImage:@"icon_map" Target:self action:@selector(showAnnotationsOnMapview:)];

    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.frame = CGRectMake(self.view.center.x, self.view.center.y, 100, 100);
    self.spinner.center = self.view.center;
    self.spinner.tag = 10;
    self.spinner.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Lunch Tyme";

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)getRestaurantData
{
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:[NSURL URLWithString:KSERVERENDPOINT]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error){
                
                self.restuarantsArray = [NSMutableArray new];

                @autoreleasepool
                {

                NSDictionary* foodDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                 options: NSJSONReadingAllowFragments
                                                                   error:&error];
                NSArray* tempRestaurantsArray = foodDictionary[@"restaurants"];
                
                    for(int i = 0; i < tempRestaurantsArray.count; i++)
                    {
                        if (tempRestaurantsArray[i] != (id)[NSNull null])
                        {
                            BRRestaurant *restaurantObj = [[BRRestaurant alloc] initWithRestaurantsObject:tempRestaurantsArray[i]];
                            [self.restuarantsArray addObject:restaurantObj];
                        }
                    }

                //UI should always be chnaged on main thread
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    //update UI in main thread.
                    [self.restaurantsCollectionView reloadData];
                    
                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(stopSpinner) userInfo:nil repeats:NO];
                });
                
            }] resume];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.restaurantsCollectionView reloadData];
}

-(void)stopSpinner{
    
    [self.spinner stopAnimating];

}

-(void)showAnnotationsOnMapview:(id)sender
{
    NSAssert(self.restuarantsArray, @"Received invalid data");

    AnnotaionsViewController *annotationsView = [self.storyboard instantiateViewControllerWithIdentifier:@"AnnotaionsViewController"];
    annotationsView.restaurantsArray = self.restuarantsArray;
    [self presentViewController:annotationsView animated:YES completion:nil];

    
}

#pragma mark <UICollectionViewDataSource>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height * 0.3169014085);

    }
    else
    {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.3169014085);
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.restuarantsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"restaurantCell" forIndexPath:indexPath];
    UIImageView *restImageView = (UIImageView *)[cell.contentView viewWithTag:1];
    UILabel *restName = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel *categoryType = (UILabel *)[cell.contentView viewWithTag:3];
    restName.font = [UIFont fontWithName:@"AvenirNext-Bold" size:[UIScreen mainScreen].bounds.size.height * 0.02816901408];
    categoryType.font = [UIFont fontWithName:@"AvenirNext-Regular" size:[UIScreen mainScreen].bounds.size.height * 0.02112676056];
    BRRestaurant *restaurantObj = self.restuarantsArray[indexPath.row];
    
    restName.text = restaurantObj.name;
    categoryType.text = restaurantObj.category;
    
    NSURL *url = [NSURL URLWithString:restaurantObj.backgroundImageURL];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (cell)
                        restImageView.image = image;
                });
            }
        }
    }];
    [task resume];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    return  headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(self.restuarantsArray, @"Received invalid data");

    RestaurantDetailsViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"RestaurantDetailsViewController"];
    detailView.restaurantObj = self.restuarantsArray[indexPath.row];
    detailView.restaurantsArray = [self.restuarantsArray copy];
    [self.navigationController pushViewController:detailView animated:YES];
    
}

@end
