#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Foundation/NSUserDefaults+Private.h>
#import <GcUniversal/GcColorPickerUtils.h>
#import <rootless.h>

@interface SearchUILabel : UILabel
@end

@interface SPUINavigationController
@property (nonatomic, weak) UIView *view;
@end

@interface SearchUICardSectionCollectionViewCell : UIView
@end

@interface SearchUIResultsCollectionViewController
@property (nonatomic, weak) UIView *view;
- (void)iterateThroughSubviews:(UIView *)view;
@end