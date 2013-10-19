//
//  ViewController.m
//  MapCode
//
//  Created by Andrea Carlevato on 10/19/13.
//  Copyright (c) 2013 TomTom Int. All rights reserved.
//

#import "ViewController.h"
#import "ResultViewController.h"

@interface ViewController ()

@property (nonatomic, strong) CLLocation *receivedLocation;
@property (weak, nonatomic) IBOutlet UIButton *showButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *waitingSpinner;

@end

@implementation ViewController


CLLocationManager *locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
	locationManager = [[CLLocationManager alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onGetMapCode:(id)sender
{
    [self.waitingSpinner startAnimating];
    self.showButton.hidden = YES;
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
    [locationManager stopUpdatingLocation];
    [self.waitingSpinner stopAnimating];
    self.showButton.hidden = NO;

    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    
    [locationManager stopUpdatingLocation];
    [self.waitingSpinner stopAnimating];
    self.showButton.hidden = NO;
    
    // set location for following result scene
    self.receivedLocation = newLocation;
    
    // launch result scene
    [self performSegueWithIdentifier:@"resultsSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"resultsSegue"])
    {
        ResultViewController *vc = [segue destinationViewController];
        vc.inputLocation = self.receivedLocation;
    }
}

@end