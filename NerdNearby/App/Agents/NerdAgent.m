#import "NerdAgent.h"

@implementation NerdAgent

@synthesize delegate;

- (void)fetchItemsWithDelegate:(id)theDelegate {
    delegate = theDelegate;
    [self fetch];
}

- (void)fetch {
    NSURL *URL = [NSURL URLWithString:@"http://nerdnearby.com?lat=40.731714&lng=-73.991431"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
}

@end
