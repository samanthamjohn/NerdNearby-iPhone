#import "NerdNearbyAppDelegate.h"
#import "FeedViewController.h"

@implementation NerdNearbyAppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    UINavigationController *navController = [[[UINavigationController alloc] init] autorelease];

    [navController pushViewController:[[[FeedViewController alloc] init] autorelease] animated:NO];
    [[self window] setRootViewController:navController];
    [[self window] makeKeyAndVisible];
    return YES;
}

- (void)dealloc {
    [window release];
    [super dealloc];
}

@end
