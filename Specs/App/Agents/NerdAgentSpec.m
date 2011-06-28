#import "NerdAgent.h"

SPEC_BEGIN(NerdAgentSpec)

describe(@"NerdAgent", ^{
    __block NerdAgent *agent;

    beforeEach(^{
        agent = [[[NerdAgent alloc] init] autorelease];
    });

    describe(@"fetchItemsWithdelegate:", ^{
        xit(@"should store the given delegate", ^{
        });
    });
});

SPEC_END
