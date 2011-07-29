#import "FeedViewController.h"
#import "App.h"
#import "NerdAgent.h"
#import "UIImageView+WebCache.h"

@interface FeedViewController (PrivateInterface)

- (void)startLocationUpdates;

@end

@implementation FeedViewController

@synthesize locationManager = locationManager_;

- (void)dealloc {
    [self setLocationManager:nil];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        [self setTitle:@"Nerd Nearby"];
    }
    return self;
}

#pragma mark - Notification handling

- (void)itemsReceived:(NSNotification *)notification {
    UITableView *tableView = (UITableView *)[self view];
    [tableView reloadData];

}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 320.f + 20.f;
}

#pragma mark - UITableView data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *NerdIdentifier = @"NerdCellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NerdIdentifier];

    UIImageView *imageView;
    UILabel *captionView;

    NSInteger index = [indexPath row];
    NerdAgent *agent = [[App sharedInstance] nerdAgent];
    NSDictionary *item = [[agent JSONArray] objectAtIndex:index];

    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NerdCellIdentifier"] autorelease];
        CGRect imageViewFrame = CGRectMake(0.f, 20.f, 320.f, 320.f);
        imageView = [[[UIImageView alloc] initWithFrame:imageViewFrame] autorelease];
        imageView.tag = kImageViewTag;
        [cell.contentView addSubview:imageView];

        CGRect captionViewFrame = CGRectMake(0.f, 0.f, 320.f, 20.f);
        captionView = [[[UILabel alloc] initWithFrame:captionViewFrame] autorelease];
        captionView.tag = kCaptionViewTag;
        [cell.contentView addSubview:captionView];
    } else {
        imageView = (UIImageView *)[cell.contentView viewWithTag:kImageViewTag];
        captionView = (UILabel *)[cell.contentView viewWithTag:kCaptionViewTag];
    }

    NSURL *imageURL = [NSURL URLWithString:[item objectForKey:@"image_tag"]];
    [imageView setImageWithURL:imageURL placeholderImage:nil];

    if ([[item objectForKey:@"text"] isKindOfClass:[NSString class]]) {
        [captionView setText:[item objectForKey:@"text"]];
    } else {
        [captionView setText:@""];
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[[App sharedInstance] nerdAgent] JSONArray] count];
}


#pragma mark - View lifecycle

- (void)loadView {
    UITableView *tableView = [[[UITableView alloc] init] autorelease];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.allowsSelection = NO;
    self.view = tableView;
}


- (void)viewDidLoad {
    [self startLocationUpdates];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemsReceived:) name:@"ItemsReceived" object:nil];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    if (oldLocation == nil) {
        [[[App sharedInstance] nerdAgent] fetchWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    }
}


#pragma mark -
#pragma mark - Private methods

- (void)startLocationUpdates {
    if (nil == [self locationManager]) {
        [self setLocationManager:[[[CLLocationManager alloc] init] autorelease]];
    }

    [[self locationManager] setDelegate:self];
    [[self locationManager] startUpdatingLocation];
}

@end
