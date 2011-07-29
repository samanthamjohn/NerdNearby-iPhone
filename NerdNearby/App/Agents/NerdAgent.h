#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define DEFAULT_LATITUDE  (40.731714f)
#define DEFAULT_LONGITUDE (-73.991431f)

@interface NerdAgent : NSObject {
}

- (void)fetch;
- (void)fetchWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;

@property (nonatomic, retain) NSMutableData *data;
@property (nonatomic, retain) NSArray *JSONArray;

@end
