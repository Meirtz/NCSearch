//
//  NCSearchController.h
//  NCSearch
//
//  Created by Meirtz on 13-7-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SpringBoard/BBWeeAppController.h"
#import "SIAlertView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "NCSearchBar.h"


#define TEST_UIAPPEARANCE 0

@interface NCSearchController : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate,BBWeeAppController,UISearchBarDelegate,UIScrollViewDelegate,UIPopoverControllerDelegate,CLLocationManagerDelegate,MKMapViewDelegate,UIPopoverControllerDelegate>
{
    UIView *_view;
    UIWindow *window;
    NSString *urlString;
    
    UISearchBar *mySearchBar;
    UISearchBar *mySearchBarGoogle;
    UISearchBar *mySearchBarWiki;
    UISearchBar *mySearchBarBing;
    
    UIScrollView* scrollview;
    
    UIView *barView;
    UIView *barViewGoogle;
    UIView *barViewWiki;
    UIView *barViewBing;
    
    int justNow;
    
    UIPageControl *searchPages;
    
    NSString *topLevelDomain;
    NSString *searchTerms;
    NSString *languageCode;
    NSString *languageCodeShort;
    
    //UIPopoverController *imagePickerPopover;
    //UIImagePickerController* myPicker
    UIViewController *newViewCon;
    NSMutableArray *searchBars;
    //id editingBar;
    NCSearchBar *activeBar;
    NSString *browser;

        
}

- (BOOL)isChromeAppInstalled;
- (UIView *)view;
+ (NSString *)language;
- (void)showCoolAlert:(NSString *)option;
//- (void)showPicker;


@property (nonatomic, strong)UIWindow *window;
@property(nonatomic,strong)NSString *urlString;
@property (nonatomic)CGFloat viewWidth;
//@property (nonatomic, strong)UIImagePickerController* myPicker;
//@property(nonatomic,strong)NSString *searchString;

@end