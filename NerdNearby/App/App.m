#import "App.h"
#import "NerdAgent.h"

@implementation App

@synthesize nerdAgent;

static void * _sharedInstance = nil;

+ (App *)sharedInstance {

    if (_sharedInstance == NULL) {
        _sharedInstance = [[self alloc] init];
    }

    return(_sharedInstance);
}

- (id)init {
    self = [super init];
    if (self) {
        nerdAgent = [[NerdAgent alloc] init];
    }
    return self;
}

- (void)dealloc {
    [nerdAgent release];
    [super dealloc];
}

@end
