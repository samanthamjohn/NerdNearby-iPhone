#import "FeedViewController.h"
#import "App.h"
#import "NerdAgent.h"

@implementation FeedViewController

- (id)init {
    self = [super init];
    if (self) {
        [self setTitle:@"Nerd Nearby"];

    }
    return self;
}

#pragma mark - Notification handling

- (void)itemsReceived:(NSNotification *)notification {
    NerdAgent *agent = [[App sharedInstance] nerdAgent];
    NSMutableString * result = [[NSMutableString alloc] init];
    for (NSObject * obj in [agent JSONArray]) {
        [result appendString:[obj description]];
    }
    [[[[UIAlertView alloc] initWithTitle:@"OH YEAH" message:result delegate:nil cancelButtonTitle:@"byebye" otherButtonTitles:nil] autorelease] show];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemsReceived:) name:@"ItemsReceived" object:nil];
    [[[App sharedInstance] nerdAgent] fetch];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
