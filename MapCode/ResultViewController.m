//
//  ResultViewController.m
//  MapCode
//
//  Created by Andrea Carlevato on 10/19/13.
//  Copyright (c) 2013 TomTom Int. All rights reserved.
//

#import "ResultViewController.h"
#import "LocMapCodeSet.h"
#import "AlternativesViewController.h"

@interface ResultViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *waitingSpinner;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UILabel *mainCountryCode;
@property (weak, nonatomic) IBOutlet UILabel *mainMapCode;
@property (weak, nonatomic) IBOutlet UILabel *fullCountryName;

@property (strong, nonatomic) LocMapCodeSet *encodeResults;

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
    locationManager = [[CLLocationManager alloc] init];
    [self updateResults];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)updateResults
{
    NSString *lat = [NSString stringWithFormat: @"%f", self.inputLocation.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat: @"%f", self.inputLocation.coordinate.longitude];
    
    self.encodeResults = [self.mapCodeEngine decodePositionWithLat:lat andLon:lon];
    
    MapCodeItem *mainResult = self.encodeResults.localMapCodes[0];
    [self.mainCountryCode setText: mainResult.countryCode];
    [self.mainMapCode setText: mainResult.mapCode];
    [self.fullCountryName setText: [NSString stringWithFormat:@"(%@)", self.encodeResults.coutryName]];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"alternativesSegue"])
    {
        AlternativesViewController *vc = [segue destinationViewController];
        vc.encodeResults = self.encodeResults;
        vc.showWorldWide = NO;
    }
    else if ([[segue identifier] isEqualToString:@"worldwideSegue"])
    {
        AlternativesViewController *vc = [segue destinationViewController];
        vc.encodeResults = self.encodeResults;
        vc.showWorldWide = YES;
    }
}

@end
