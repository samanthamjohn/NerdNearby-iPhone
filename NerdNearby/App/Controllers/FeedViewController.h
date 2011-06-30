#import <UIKit/UIKit.h>

@interface FeedViewController : UIViewController<UITableViewDataSource> {

}

- (void)itemsReceived:(NSNotification *)notification;

@end
