#import "FeedViewController.h"

SPEC_BEGIN(FeedViewControllerSpec)

describe(@"FeedViewController", ^{

    __block FeedViewController *controller;

    beforeEach(^{
        controller = [[[FeedViewController alloc] init] autorelease];
    });

    it(@"should set its title to Nerd Nearby", ^{
        assertThat([controller title], equalTo(@"Nerd Nearby"));
    });
});

SPEC_END
