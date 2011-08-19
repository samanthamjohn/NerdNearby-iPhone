#if TARGET_IPHONE_SIMULATOR

#import "CLLocationManager+NerdNearby.h"

@implementation CLLocationManager (Simulator)

-(void)startUpdatingLocation {
    //Washington Monument:
    CLLocation *fakeLocation = [[[CLLocation alloc] initWithLatitude:38.890164 longitude:-77.034588] autorelease];

    [self.delegate locationManager:self
               didUpdateToLocation:fakeLocation
                      fromLocation:nil];
}

@end
#endif
