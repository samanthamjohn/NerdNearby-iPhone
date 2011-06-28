#import <Foundation/Foundation.h>

@class NerdHTTPInterface;

@interface NerdAgent : NSObject {

}

- (void)fetchItemsWithDelegate:(id)theDelegate;
- (void)fetch;

@property (nonatomic, assign) id delegate;

@end
