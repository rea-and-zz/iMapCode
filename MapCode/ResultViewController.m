//
//  ResultViewController.m
//  MapCode
//
//  Created by Andrea Carlevato on 10/19/13.
//  Copyright (c) 2013 TomTom Int. All rights reserved.
//

#import "ResultViewController.h"
#import "MapCode.h"
#import "EncodeResult.h"

@interface ResultViewController ()

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *localResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryCode;
@property (weak, nonatomic) IBOutlet UILabel *parentMapCode;
@property (weak, nonatomic) IBOutlet UILabel *parentCountryCode;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *waitingSpinner;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *vcNavItem;
@property (weak, nonatomic) IBOutlet UILabel *parentCodeLabel;

@end

@implementation ResultViewController

CLLocationManager *locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    self.vcNavItem.leftBarButtonItem = backButton;
    
    locationManager = [[CLLocationManager alloc] init];
    [self updateResults];
}

-(void)goBack
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)updateResults
{
    MapCode *mapCode = [MapCode new];
    NSString *in = NULL;
    in = [NSString stringWithFormat: @"%f", self.inputLocation.coordinate.latitude];
    in = [in stringByReplacingOccurrencesOfString:@"." withString:@""];
    long y = (long)[in longLongValue];
    in = [NSString stringWithFormat: @"%f", self.inputLocation.coordinate.longitude];
    in = [in stringByReplacingOccurrencesOfString:@"." withString:@""];
    long x = (long)[in longLongValue];
    
    EncodeResult *result = [mapCode decodePositionWithX:x andY:y];
    
    [self.resultLabel setText:result.worldMapCode];
    [self.localResultLabel setText:result.localMapCode];
    [self.countryCode setText:result.localCountryCode];
    
    if (result.parentMapCode.length > 0)
    {
        self.parentCodeLabel.hidden = NO;
        self.parentMapCode.hidden = NO;
        self.parentCountryCode.hidden = NO;
        [self.parentMapCode setText:result.parentMapCode];
        [self.parentCountryCode setText:result.parentCountryCode];
    }
    else
    {
        self.parentCodeLabel.hidden = YES;
        self.parentMapCode.hidden = YES;
        self.parentCountryCode.hidden = YES;
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
    [locationManager stopUpdatingLocation];
    [self.waitingSpinner stopAnimating];
    self.refreshButton.hidden = NO;
    
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    
    [locationManager stopUpdatingLocation];
    [self.waitingSpinner stopAnimating];
    self.refreshButton.hidden = NO;
    
    // update location
    self.inputLocation = newLocation;
    
    // update view
    [self updateResults];
}

- (IBAction)onRefreshLocationButton:(id)sender
{
    [self.waitingSpinner startAnimating];
    self.refreshButton.hidden = YES;
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
