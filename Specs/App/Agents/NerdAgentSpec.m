#import "NerdAgent.h"

SPEC_BEGIN(NerdAgentSpec)

describe(@"NerdAgent", ^{
    __block NerdAgent *agent;

    beforeEach(^{
        agent = [[[NerdAgent alloc] init] autorelease];
    });

    describe(@"fetch", ^{
        it(@"should call fetchWithLocation with a default location", ^{
            id mockAgent = [OCMockObject partialMockForObject:agent];
            [[mockAgent expect] fetchWithLatitude:DEFAULT_LATITUDE longitude:DEFAULT_LONGITUDE];

            [agent fetch];

            [mockAgent verify];
        });
    });

    describe(@"fetchWithLocation:", ^{
        xit(@"should initiate a request for JSON with itself as the connection delegate", ^{});
    });

    describe(@"connection:didReceiveResponse:", ^{
        it(@"should initialize the data storage", ^{
            [agent connection:nil didReceiveResponse:nil];
            assertThat([agent data], instanceOf([NSMutableData class]));
        });
    });

    describe(@"connection:didReceiveData: after a response has been received", ^{
        it(@"should append the data to its internal data storage", ^{
            [agent connection:nil didReceiveResponse:nil];
            NSData *data = [NSData dataWithBytes:"yeah" length:5];
            [agent connection:nil didReceiveData:data];
            assertThatInt([[agent data] length], equalToInt(5));
        });
    });

    describe(@"connection:didFailWithError:", ^{});

    describe(@"connectionDidFinishLoading:", ^{

        __block id mockNotificationCenter;

        beforeEach(^{
            mockNotificationCenter = [OCMockObject partialMockForObject:[NSNotificationCenter defaultCenter]];
            [[mockNotificationCenter expect] postNotificationName:@"ItemsReceived" object:agent];
            NSData *data = [NSData dataWithBytes:"[\"yeah\"]" length:7];
            [agent setData:[data mutableCopy]];
            [agent connectionDidFinishLoading:nil];
        });

        it(@"should turn the data into a JSON array", ^{
            assertThat([agent JSONArray], equalTo([NSArray arrayWithObject:@"yeah"]));
        });

        it(@"should clear the data object", ^{
            assertThat([agent data], is(nilValue()));
        });

        it(@"should send notification that data has been received", ^{
            [mockNotificationCenter verify];
        });
    });
});

SPEC_END
