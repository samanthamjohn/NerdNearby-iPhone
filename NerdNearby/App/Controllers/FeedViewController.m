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
    return 320.f + 30.f;
}

#pragma mark - UITableView data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [indexPath row];
    NerdAgent *agent = [[App sharedInstance] nerdAgent];
    NSDictionary *item = [[agent JSONArray] objectAtIndex:index];
    NSString *cellIdentifier;
    BOOL tweet = NO;

    if ([[item objectForKey:@"feed_item_type"] isEqualToString:@"tweet"]) {
        tweet = YES;
        cellIdentifier = @"TweetCellIdentifier";
    } else {
        cellIdentifier = @"NerdCellIdentifier";
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UIImageView *imageView;
    UILabel *captionView;

    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];

        imageView = [[[UIImageView alloc] init] autorelease];
        imageView.tag = kImageViewTag;
        [cell.contentView addSubview:imageView];

        captionView = [[[UILabel alloc] init] autorelease];
        captionView.tag = kCaptionViewTag;
        captionView.lineBreakMode = UILineBreakModeWordWrap;
        captionView.numberOfLines = 0;
        captionView.font = [UIFont fontWithName:@"Helvetica" size:18.f];
        [cell.contentView addSubview:captionView];
    } else {
        imageView = (UIImageView *)[cell.contentView viewWithTag:kImageViewTag];
        captionView = (UILabel *)[cell.contentView viewWithTag:kCaptionViewTag];
    }

    CGRect imageViewFrame;
    CGRect captionViewFrame;

    if (tweet) {
        imageViewFrame = CGRectMake(0.f, 0.f, 48.f, 48.f);
        captionViewFrame = CGRectMake(0.f, 48.f + 12.f, 320.f, 240.f);
    } else {
        imageViewFrame = CGRectMake(0.f, 20.f, 320.f, 320.f);
        captionViewFrame = CGRectMake(0.f, 0.f, 320.f, 20.f);
    }

    imageView.frame = imageViewFrame;
    captionView.frame = captionViewFrame;

    NSURL *imageURL = [NSURL URLWithString:[item objectForKey:@"image_tag"]];
    [imageView setImageWithURL:imageURL placeholderImage:nil];

    NSString *captionText = [item objectForKey:@"text"];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:18.f];
    CGSize captionSize = [captionText sizeWithFont:font constrainedToSize:CGSizeMake(320.f, 240.f) lineBreakMode:UILineBreakModeWordWrap];
    captionViewFrame.size = captionSize;
    [captionView setText:captionText];

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
