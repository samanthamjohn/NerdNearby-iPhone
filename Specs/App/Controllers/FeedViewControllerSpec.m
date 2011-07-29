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

    describe(@"itemsReceived:", ^{
        it(@"should reload the table view", ^{
            id mockTableView = [OCMockObject niceMockForClass:[UITableView class]];
            [[mockTableView expect] reloadData];
            [controller setView:mockTableView];

            [controller itemsReceived:nil];

            [mockTableView verify];
        });
    });

    describe(@"loadView", ^{

        __block UITableView *tableView;

        beforeEach(^{
            [controller loadView];
            tableView = (UITableView *)[controller view];
        });

        it(@"should have a UITableView as its view", ^{
            assertThat(tableView, instanceOf([UITableView class]));
        });

        it(@"should set the controller as the UITableView's data source", ^{
            assertThat([tableView dataSource], sameInstance(controller));
        });

        it(@"should set the controller as the UITableView's delegate", ^{
            assertThat([tableView delegate], sameInstance(controller));
        });
    });

    describe(@"tableView:numberOfRowsInSection:", ^{
        it(@"should return the number of items in the agent's json array", ^{
            id mockAgent = [OCMockObject partialMockForObject:[[App sharedInstance] nerdAgent]];
            NSArray *mockArray = [NSArray arrayWithObject:@"hai!"];
            [[[mockAgent stub] andReturn:mockArray] JSONArray];

            assertThatInt([controller tableView:nil numberOfRowsInSection:0], equalToInt(1));
        });
    });

    describe(@"cell returned from tableView:cellForRowAtIndexPath:", ^{

        __block UITableViewCell *cell;

        beforeEach(^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            cell = [controller tableView:nil cellForRowAtIndexPath:indexPath];
        });

        it(@"should be a UITableViewCell", ^{
            assertThat(cell, instanceOf([UITableViewCell class]));
        });

        it(@"should have a reuseIdentifier of NerdCellIdentifier", ^{
            assertThat([cell reuseIdentifier], equalTo(@"NerdCellIdentifier"));
        });

        it(@"should have an image view", ^{
            assertThat([[cell contentView] viewWithTag:kImageViewTag], instanceOf([UIImageView class]));
        });

        it(@"should have a caption view", ^{
            assertThat([[cell contentView] viewWithTag:kCaptionViewTag], instanceOf([UILabel class]));
        });

    });

    describe(@"viewDidLoad", ^{

        beforeEach(^{
            [controller loadView];
        });

        it(@"should register for the 'ItemsReceived' notification", ^{
            id mockNotificationCenter = [OCMockObject partialMockForObject:[NSNotificationCenter defaultCenter]];
            [[mockNotificationCenter expect] addObserver:controller selector:@selector(itemsReceived:) name:@"ItemsReceived" object:nil];

            [controller viewDidLoad];

            [mockNotificationCenter verify];
        });

        describe(@"the location manager", ^{
            beforeEach(^{
                [controller viewDidLoad];
            });

            it(@"should be created", ^{
                assertThat([controller locationManager], instanceOf([CLLocationManager class]));
            });

            it(@"should set the delegate to be the controller", ^{
                assertThat([[controller locationManager] delegate], sameInstance(controller));
            });
        });
    });

    describe(@"locationManager:didUpdateToLocation:fromLocation:", ^{
        describe(@"when the fromLocation is nil", ^{
            it(@"should trigger an update with the location", ^{
                id mockAgent = [OCMockObject partialMockForObject:[[App sharedInstance] nerdAgent]];
                CLLocation *newLocation = [[[CLLocation alloc] initWithLatitude:10.f longitude:20.f] autorelease];

                [[mockAgent expect] fetchWithLatitude:10.f longitude:20.f];
                [controller locationManager:nil didUpdateToLocation:newLocation fromLocation:nil];

                [mockAgent verify];
            });
        });
    });
});

SPEC_END
