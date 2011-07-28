#import <UIKit/UIKit.h>

enum CellViewTag {
    kImageViewTag = 2047,
    kCaptionViewTag
    };

@interface FeedViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {

}

- (void)itemsReceived:(NSNotification *)notification;

@end
