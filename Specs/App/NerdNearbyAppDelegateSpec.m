#import "NerdNearbyAppDelegate.h"

SPEC_BEGIN(NerdNearbyAppDelegateSpec)

describe(@"NerdNearbyAppDelegate", ^{
    describe(@"application:didFinishLaunchingWithOptions:", ^{
        it(@"should add a navigation controller to the window", ^{
            NerdNearbyAppDelegate *appDelegate = [[[NerdNearbyAppDelegate alloc] init] autorelease];
            appDelegate.window = [[[UIWindow alloc] init] autorelease];

            [appDelegate application:nil didFinishLaunchingWithOptions:nil];

            assertThat(appDelegate.window.rootViewController, instanceOf([UINavigationController class]));
        });
    });
});

SPEC_END
