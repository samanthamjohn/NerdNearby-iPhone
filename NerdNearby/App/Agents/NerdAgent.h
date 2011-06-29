#import <Foundation/Foundation.h>

@class NerdHTTPInterface;

@interface NerdAgent : NSObject {
}

- (void)fetch;

@property (nonatomic, retain) NSMutableData *data;
@property (nonatomic, retain) NSArray *JSONArray;

@end
