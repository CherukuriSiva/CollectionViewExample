//
//  InternetsViewController.m
//  BR iOS Test
//
//  Created by Apple on 09/11/16.
//  Copyright © 2016 Bottle Rocket. All rights reserved.
//

#import "InternetsViewController.h"
#define KBOTTLEROCKETSSERVERURL @"https://www.bottlerocketstudios.com"

@interface InternetsViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation InternetsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.internetsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:KBOTTLEROCKETSSERVERURL]]];
    self.navigationController.navigationBarHidden = YES;

    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.frame = CGRectMake(self.view.center.x, self.view.center.y, 100, 100);
    self.spinner.center = self.view.center;
    self.spinner.tag = 10;
    self.spinner.backgroundColor = [UIColor lightGrayColor];
    [self.spinner startAnimating];
    [self.internetsWebView addSubview:self.spinner];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [self.spinner stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
