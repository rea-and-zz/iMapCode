//
//  MapCode.mm
//  MapCode
//
//  Created by Andrea Carlevato on 10/19/13.
//  Copyright (c) 2013 TomTom Int. All rights reserved.
//

#import "MapCode.h"
#import "mapcoder.h"

@implementation MapCode


- (EncodeResult *)decodePositionWithX:(long)x andY:(long)y
{
    char worldResult[16] = "";
    char localResult[16] = "";
    const char *worldIso = "AAA";
    char iso_found[16];
    
    int areaCode = findAreaFor(x, y, -1);
    
    EncodeResult *result = [EncodeResult new];
    
    // Fills the "parent" map code, if applicable (US, RUSSIA, etc...)
    int parentCountry = stateparent(areaCode);
    if (parentCountry >= 0)
    {
        char parentResult[16];
        const char *isoParent = entity_iso3(parentCountry);
        disambiguate(parentCountry);
        mapcode_encode(parentResult, y, x, isoParent, iso_found);
        
        result.parentCountryCode = [NSString stringWithUTF8String:isoParent];
        result.parentMapCode = [NSString stringWithUTF8String:parentResult];
    }
    else
    {
        result.parentCountryCode = @"";
        result.parentMapCode = @"";
    }
    
    // Fill the local map code
    const char *iso3 = entity_iso3(areaCode);
    result.localCountryCode = [NSString stringWithUTF8String:iso3];
    if (parentCountry >= 0)
    {
        // cleanup the country name when there is a country parent
        result.localCountryCode = [result.localCountryCode substringFromIndex:1];
    }
    mapcode_encode(localResult, y, x, iso3, iso_found);
    result.localMapCode = [NSString stringWithUTF8String:localResult];
    
    // Fill the worldwide map code
    mapcode_encode(worldResult, y, x, worldIso, iso_found);
    result.worldMapCode = [NSString stringWithUTF8String:worldResult];
    
    return result;
}

@end
