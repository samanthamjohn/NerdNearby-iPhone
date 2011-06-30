#import "FeedViewController.h"
#import "App.h"
#import "NerdAgent.h"

SPEC_BEGIN(FeedViewControllerSpec)

describe(@"FeedViewController", ^{

    __block FeedViewController *controller;

    beforeEach(^{
        controller = [[[FeedViewController alloc] init] autorelease];
    });

    it(@"should set its title to Nerd Nearby", ^{
        assertThat([controller title], equalTo(@"Nerd Nearby"));
    });

    describe(@"itemsReceived", ^{
        xit(@"should do something with the items", ^{});
    });

    describe(@"viewDidLoad", ^{
        it(@"should register for the 'ItemsReceived' notification", ^{
            id mockNotificationCenter = [OCMockObject partialMockForObject:[NSNotificationCenter defaultCenter]];
            [[mockNotificationCenter expect] addObserver:controller selector:@selector(itemsReceived:) name:@"ItemsReceived" object:nil];

            [controller viewDidLoad];

            [mockNotificationCenter verify];
        });

        it(@"should trigger an update", ^{
            id mockAgent = [OCMockObject partialMockForObject:[[App sharedInstance] nerdAgent]];
            [[mockAgent expect] fetch];

            [controller viewDidLoad];

            [mockAgent verify];
        });
    });
});

SPEC_END
