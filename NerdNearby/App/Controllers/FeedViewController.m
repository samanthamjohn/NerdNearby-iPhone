#import "FeedViewController.h"
#import "App.h"
#import "NerdAgent.h"
#import "UIImageView+WebCache.h"

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
    self.view = tableView;
}


- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemsReceived:) name:@"ItemsReceived" object:nil];
    [[[App sharedInstance] nerdAgent] fetch];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
