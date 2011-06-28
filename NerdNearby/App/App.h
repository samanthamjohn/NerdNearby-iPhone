#import <Foundation/Foundation.h>

@class NerdAgent;

@interface App : NSObject {
}

@property (nonatomic, retain) NerdAgent *nerdAgent;

+ (App *)sharedInstance;

@end
