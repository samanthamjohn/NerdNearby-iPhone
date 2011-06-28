#import "NerdAgent.h"

SPEC_BEGIN(NerdAgentSpec)

describe(@"NerdAgent", ^{
    __block NerdAgent *agent;

    beforeEach(^{
        agent = [[[NerdAgent alloc] init] autorelease];
    });

    describe(@"fetchItemsWithDelegate:", ^{
        xit(@"should initiate a connection with itself as the connection delegate", ^{});
        xit(@"should set its delegate to the delegate provided", ^{});
    });

    describe(@"connection:didReceiveResponse:", ^{});
    describe(@"connection:didReceiveData:", ^{});
    describe(@"connection:didFailWithError:", ^{});
    describe(@"connectionDidFinishLoading:", ^{});

});

SPEC_END
