#import "NerdNearbyAppDelegate.h"
#import "FeedViewController.h"

SPEC_BEGIN(NerdNearbyAppDelegateSpec)

describe(@"NerdNearbyAppDelegate", ^{
    describe(@"application:didFinishLaunchingWithOptions:", ^{

        __block UINavigationController *navController;

        beforeEach(^{
            NerdNearbyAppDelegate *appDelegate = [[[NerdNearbyAppDelegate alloc] init] autorelease];
            appDelegate.window = [[[UIWindow alloc] init] autorelease];
            [appDelegate application:nil didFinishLaunchingWithOptions:nil];
            navController = (UINavigationController *)[[appDelegate window] rootViewController];
        });

        it(@"should add a feed view controller to the navigation controller", ^{
            assertThat([navController topViewController], instanceOf([FeedViewController class]));
        });
    });
});

SPEC_END
