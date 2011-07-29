#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

enum CellViewTag {
    kImageViewTag = 2047,
    kCaptionViewTag
    };

@interface FeedViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate> {

}

@property (nonatomic, retain) CLLocationManager *locationManager;

- (void)itemsReceived:(NSNotification *)notification;

@end
