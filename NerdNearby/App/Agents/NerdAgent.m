#import "NerdAgent.h"
#import <YAJLiOS/YAJL.h>

@implementation NerdAgent

@synthesize data, JSONArray;

- (void)fetch {
    NSURL *URL = [NSURL URLWithString:@"http://nerdnearby.com/feed_items.json?lat=40.731714&lng=-73.991431"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self setData:[NSMutableData data]];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData {
    [data appendData:theData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self setJSONArray:[data yajl_JSON]];
    [self setData:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ItemsReceived" object:self];
}

@end
