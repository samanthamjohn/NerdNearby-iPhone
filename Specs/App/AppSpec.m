#import "App.h"
#import "NerdAgent.h"

SPEC_BEGIN(AppSpec)

describe(@"App", ^{

    __block App* app;

    beforeEach(^{
        app = [App sharedInstance];
    });

    describe(@"sharedInstance", ^{
        it(@"should return the same App on each call", ^{
            App *app2 = [App sharedInstance];
            assertThat(app2, sameInstance(app));
        });
    });

    describe(@"nerdAgent", ^{
        it(@"should have a nerdAgent", ^{
            NerdAgent *agent = [app nerdAgent];
            assertThat(agent, instanceOf([NerdAgent class]));
        });
    });
});

SPEC_END
