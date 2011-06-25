#import "NerdNearbyAppDelegate.h"

@implementation NerdNearbyAppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[self window] setRootViewController:[[[UINavigationController alloc] init] autorelease]];
    [[self window] makeKeyAndVisible];
    return YES;
}

- (void)dealloc {
    [window release];
    [super dealloc];
}

@end
