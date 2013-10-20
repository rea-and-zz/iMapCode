//
//  AlternativesViewController.m
//  MapCode
//
//  Created by Andrea Carlevato on 10/20/13.
//  Copyright (c) 2013 TomTom Int. All rights reserved.
//

#import "AlternativesViewController.h"

@interface AlternativesViewController ()

@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UIView *alt1_box;
@property (weak, nonatomic) IBOutlet UILabel *alt1_countryCode;
@property (weak, nonatomic) IBOutlet UILabel *alt1_mapCode;
@property (weak, nonatomic) IBOutlet UIView *alt2_box;
@property (weak, nonatomic) IBOutlet UILabel *alt2_countryCode;
@property (weak, nonatomic) IBOutlet UILabel *alt2_mapCode;
@property (weak, nonatomic) IBOutlet UIView *alt3_box;
@property (weak, nonatomic) IBOutlet UILabel *alt3_countryCode;
@property (weak, nonatomic) IBOutlet UILabel *alt3_mapCode;

@end

@implementation AlternativesViewController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    self.alt2_box.hidden = YES;
    self.alt3_box.hidden = YES;
    
    if (self.showWorldWide)
    {
        self.alt1_countryCode.hidden = TRUE;
        [self.alt1_mapCode setTextAlignment:NSTextAlignmentCenter];
        
        [self.introLabel setText:[NSString stringWithFormat:@"International mapcode for your location:"]];
        [self.alt1_mapCode setText:self.encodeResults.worldMapCode];
    }
    else
    {
        self.alt1_countryCode.hidden = NO;
        [self.alt1_mapCode setTextAlignment:NSTextAlignmentRight];
        
        [self.introLabel setText:[NSString stringWithFormat:@"Mapcode alternatives for your location in %@:", self.encodeResults.coutryName]];
    
        MapCodeItem *alt = self.encodeResults.localMapCodes[1];
        [self.alt1_countryCode setText:alt.countryCode];
        [self.alt1_mapCode setText:alt.mapCode];
    
        if (self.encodeResults.localMapCodes.count > 2)
        {
            self.alt2_box.hidden = NO;
            alt = self.encodeResults.localMapCodes[2];
            [self.alt2_countryCode setText:alt.countryCode];
            [self.alt2_mapCode setText:alt.mapCode];
        }
    
        if (self.encodeResults.localMapCodes.count > 3)
        {
            self.alt3_box.hidden = NO;
            alt = self.encodeResults.localMapCodes[3];
            [self.alt3_countryCode setText:alt.countryCode];
            [self.alt3_mapCode setText:alt.mapCode];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
