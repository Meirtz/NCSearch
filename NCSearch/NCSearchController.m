//
//  NCSearchController.m
//  NCSearch
//
//  Created by Meirtz on 13-7-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "NCSearchController.h"
#import "UIKit/UIApplication.h"

#define kPrefs_Path @"/var/mobile/Library/Preferences/com.sa.ncsearchpreference.plist"
#define kPrefs_Path1 @"/var/mobile/Library/Preferences/com.sa.ncsearchpreferencenew.plist"
@implementation NCSearchController

@synthesize urlString;
@synthesize window;
@synthesize viewWidth;


-(id)init
{
	if ((self = [super init]))
	{
        
        NSDictionary *data;
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:kPrefs_Path1] == YES) {
            searchBars = [[NSMutableArray alloc] initWithContentsOfFile:kPrefs_Path1];
        }else{
            //init AlertView
            searchBars = [[NSMutableArray alloc] init];
            data = [[NSDictionary alloc] initWithContentsOfFile:kPrefs_Path];
            
            /*#error 啦啦啦就在这里
             
             
             
             
             
             if ( [[data valueForKey:@"Browser"] integerValue] == 1) {
             if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlechrome://www.google.com"]] == YES ) {
             browser = @"googlechrome";
             }
             else{
             browser = @"http";
             }
             }else {
             browser = @"http";
             }*/
            
            
            if ([data valueForKey:@"searchPage1"]  == nil) {
                [searchBars addObject:@"Baidu"];
            }else{
                [searchBars addObject:[@[@"Baidu",@"Google",@"Wikipedia",@"Bing"] objectAtIndex:[[data valueForKey:@"searchPage1"] integerValue]]];
            }
            
            if ([data valueForKey:@"searchPage2"]  == nil) {
                [searchBars addObject:@"Google"];
            }else{
                [searchBars addObject:[@[@"Baidu",@"Google",@"Wikipedia",@"Bing"] objectAtIndex:[[data valueForKey:@"searchPage2"] integerValue]]];
            }
            
            if ([data valueForKey:@"searchPage3"]  == nil) {
                [searchBars addObject:@"Wikipedia"];
            }else{
                [searchBars addObject:[@[@"Baidu",@"Google",@"Wikipedia",@"Bing"] objectAtIndex:[[data valueForKey:@"searchPage3"] integerValue]]];
            }
            
            if ([data valueForKey:@"searchPage4"]  == nil) {
                [searchBars addObject:@"Bing"];
            }else{
                [searchBars addObject:[@[@"Baidu",@"Google",@"Wikipedia",@"Bing"] objectAtIndex:[[data valueForKey:@"searchPage4"] integerValue]]];
            }

        }
                
	}
	return self;
}

-(void)dealloc
{
	//[_view release];
	//[super dealloc];
}

- (void)autoResizing:(UIView *)viewToResize{
    [viewToResize setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth];
}

- (NSInteger)tagForString:(NSString *)string{
    if ([string isEqualToString:@"Baidu"]) {
        return 0;
    }else if ([string isEqualToString:@"Google"]){
        return 1;
    }else if ([string isEqualToString:@"Wikipedia"]){
        return 2;
    }else{
        return 3;
    }
}

- (UIView *)view
{
    
    
    
    
    
    
	if (_view == nil)
	{
        viewWidth = [self detectShowOrientation];
        
        _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
        _view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        justNow = 0;
        _view.autoresizesSubviews = YES;
        
        
        if ([[NCSearchController language] hasPrefix:@"zh"]) {
            topLevelDomain = @"com.hk";
            languageCode = @"zh_cn";
            languageCodeShort = @"zh";
        }
        else{
            topLevelDomain = @"com";
            languageCode = @"en_us";
            languageCodeShort = @"en";
        }
        
        
               
        
        
        CGRect frame = CGRectMake(0, 0, viewWidth, 50);
        scrollview = [[UIScrollView alloc]initWithFrame:frame];//定义单页ScrollView大小
        
        //frame = CGRectMake(0, 0, viewWidth, 50);
        
        [self autoResizing:scrollview];
        barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, 50)];//定义包含的UIView的大小、
        barViewGoogle = [[UIView alloc]initWithFrame:CGRectMake(viewWidth, 0, viewWidth, 50)];
        barViewWiki = [[UIView alloc]initWithFrame:CGRectMake(viewWidth*2, 0, viewWidth, 50)];
        barViewBing = [[UIView alloc]initWithFrame:CGRectMake(viewWidth*3, 0, viewWidth, 50)];
        
        
        
        scrollview.showsHorizontalScrollIndicator = NO;//关闭滚动时的指示条
        [scrollview setContentOffset:CGPointMake(viewWidth, 0)];
        [scrollview addSubview:barView];//将UIView的实例barView添加到scrollView
        [scrollview addSubview:barViewGoogle];
        [scrollview addSubview:barViewWiki];
        [scrollview addSubview:barViewBing];
        
        
        scrollview.contentSize = CGSizeMake(viewWidth*4, 50);//定义总的大小
        scrollview.pagingEnabled=YES;//是否自己动适应
        scrollview.delegate=self;
        
        
        
        
        
        
        
        
        //-----------第一个UISearchBar实例
        mySearchBar = [[NCSearchBar alloc]initWithFrame:CGRectMake(0, 0, viewWidth, 41)];
        mySearchBar.delegate = self;
        [mySearchBar setTag:[self tagForString:[searchBars objectAtIndex:0]]];
        mySearchBar.showsCancelButton = NO;
        mySearchBar.barStyle = 3;
        mySearchBar.placeholder=[@[@"Search Baidu",@"Search Google",@"Search Wikipedia",@"Search Bing"] objectAtIndex:mySearchBar.tag];
        mySearchBar.showsBookmarkButton = NO;
        [mySearchBar sizeToFit];
        [self autoResizing:mySearchBar];
        mySearchBar.autoresizesSubviews = YES;
        
        //-----------第二个UISearchBar实例
        
        
        mySearchBarGoogle = [[NCSearchBar alloc]initWithFrame:CGRectMake(0, 0, viewWidth, 41)];
        mySearchBarGoogle.delegate = self;
        [mySearchBarGoogle setTag:[self tagForString:[searchBars objectAtIndex:1]]];
        mySearchBarGoogle.showsCancelButton = NO;
        mySearchBarGoogle.barStyle = 3;
        mySearchBarGoogle.placeholder=[@[@"Search Baidu",@"Search Google",@"Search Wikipedia",@"Search Bing"] objectAtIndex:mySearchBarGoogle.tag];
        //mySearchBar.placeholder=[@[@"Search Baidu",@"Search Google",@"Search Wikipedia",@"Search Bing"] objectAtIndex:mySearchBar.tag];
        
        mySearchBarGoogle.showsBookmarkButton = NO;
        [mySearchBarGoogle sizeToFit];
        [self autoResizing:mySearchBarGoogle];
        mySearchBarGoogle.autoresizesSubviews = YES;
        //-----------第三个UISearchBar实例
        
        
        mySearchBarWiki = [[NCSearchBar alloc]initWithFrame:CGRectMake(0, 0, viewWidth, 41)];
        mySearchBarWiki.delegate = self;
        [mySearchBarWiki setTag:[self tagForString:[searchBars objectAtIndex:2]]];
        mySearchBarWiki.showsCancelButton = NO;
        mySearchBarWiki.barStyle = 3;
        mySearchBarWiki.placeholder=[@[@"Search Baidu",@"Search Google",@"Search Wikipedia",@"Search Bing"] objectAtIndex:mySearchBarWiki.tag];
        //mySearchBarGoogle.placeholder=[@[@"Search Baidu",@"Search Google",@"Search Wikipedia",@"Search Bing"] objectAtIndex:mySearchBar.tag];
        //mySearchBar.placeholder=[@[@"Search Baidu",@"Search Google",@"Search Wikipedia",@"Search Bing"] objectAtIndex:mySearchBar.tag];
        
        mySearchBarWiki.showsBookmarkButton = NO;
        [mySearchBarWiki sizeToFit];
        [self autoResizing:mySearchBarWiki];
        mySearchBarWiki.autoresizesSubviews = YES;
        
        
        //------------第四个UISearchBar实例
        
        
        mySearchBarBing = [[NCSearchBar alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 41)];
        mySearchBarBing.delegate = self;
        [mySearchBarBing setTag:[self tagForString:[searchBars objectAtIndex:3]]];
        mySearchBarBing.showsCancelButton = NO;
        mySearchBarBing.barStyle = 3;
        mySearchBarBing.placeholder=[@[@"Search Baidu",@"Search Google",@"Search Wikipedia",@"Search Bing"] objectAtIndex:mySearchBarBing.tag];
        //mySearchBarWiki.placeholder=[@[@"Search Baidu",@"Search Google",@"Search Wikipedia",@"Search Bing"] objectAtIndex:mySearchBar.tag];
        //mySearchBarGoogle.placeholder=[@[@"Search Baidu",@"Search Google",@"Search Wikipedia",@"Search Bing"] objectAtIndex:mySearchBar.tag];
        //mySearchBar.placeholder=[@[@"Search Baidu",@"Search Google",@"Search Wikipedia",@"Search Bing"] objectAtIndex:mySearchBar.tag];
        
        mySearchBarBing.showsBookmarkButton = NO;
        [mySearchBarBing sizeToFit];
        [self autoResizing:mySearchBarBing];
        mySearchBarBing.autoresizesSubviews = YES;
        
        //-----------------------------------
        
        
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                searchPages = [[UIPageControl alloc] initWithFrame:CGRectMake(600/2-60, 44, 60, 6)];
            }
            else {
                searchPages = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-30, 44, 60, 6)];
            }
            
            
            searchPages.numberOfPages = 4;
            
            [searchPages addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];//UIPageview
            
            
            
            
            searchPages.currentPage = (scrollview.contentOffset.x+self.view.frame.size.width/2) / viewWidth;
            
            //[self.view addSubview:searchPages];

        
               
        
        
        [barView addSubview:mySearchBar];
        [barViewGoogle addSubview:mySearchBarGoogle];
        [barViewWiki addSubview:mySearchBarWiki];
        [barViewBing addSubview:mySearchBarBing];
        
        [self.view addSubview:scrollview];
        
	}
    /*else
     {
     _view.frame = CGRectMake(0, 0, viewWidth, 71);
     barView.frame = CGRectMake(0, 0, viewWidth, 50);
     barViewGoogle.frame = CGRectMake(viewWidth, 0, viewWidth, 50);
     barViewWiki.frame = CGRectMake(viewWidth*2, 0, viewWidth, 50);
     scrollview.frame = CGRectMake(0, 0, viewWidth, 50);
     mySearchBar.frame = CGRectMake(0, 0, viewWidth, 41);
     mySearchBarGoogle.frame = CGRectMake(0, 0, viewWidth, 41);
     mySearchBarWiki.frame = CGRectMake(0, 0, viewWidth, 41);
     
     searchPages.frame = CGRectMake(viewWidth/2-30, 38, 60, 15);
     }*/
    
	return _view;
}

- (float)viewHeight
{
	return 50.0f;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    searchTerms = searchText;
    
}



- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    /*BOOL beTmp = NO;
     
     if ( editingBar != nil ) {
     [editingBar resignFirstResponder];
     [editingBar setShowsCancelButton:NO animated:YES];
     [editingBar setText:@""];
     [editingBar setPlaceholder:[@[@"Search Baidu",@"Search Google",@"Search Wikipedia",@"Search Bing"] objectAtIndex:((NCSearchBar *)editingBar).tag]];
     beTmp = YES;
     
     }if (editingBar != searchBar) {
     editingBar = searchBar;
     [searchBar setShowsCancelButton:YES animated:YES];
     [searchBar setPlaceholder:@""];
     }*/
    
    
    
    if (activeBar == nil) {
        activeBar = searchBar;
        [activeBar setShowsCancelButton:YES animated:YES];
        
    }else{
        [activeBar setShowsCancelButton:NO animated:YES];
        UITextField *searchField;
        for(id view in activeBar.subviews)
        {
            if([view isKindOfClass:[UITextField class]])
            {
                searchField = view;
                break;
            }
        }
        [searchField setText:@""];
        activeBar = nil;
        activeBar = searchBar;
        [activeBar setShowsCancelButton:YES animated:YES];
        
        
        
        
        NSString *plistPath = @"/System/Library/WeeAppPlugins/NCSearch.bundle/Info.plist";
        NSMutableDictionary *plistData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        if ([plistData valueForKey:@"isFirst"] == nil) {
            //do something
            [self showCoolAlert:@"first"];
            [plistData setValue:@"NO" forKey:@"isFirst"];
            [plistData writeToFile:plistPath atomically:YES];
            
        }else{
            BOOL isFirst = [[plistData valueForKey:@"isFirst"] boolValue];
            
            if ( isFirst == YES) {
                [self showCoolAlert:@"first"];
                
                
                [plistData setValue:@"NO" forKey:@"isFirst"];
                [plistData writeToFile:plistPath atomically:YES];
            }
        }
    }
    
    return YES;
}


- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    
    //[searchBar setShowsCancelButton:NO animated:YES];
    NSArray *array = @[@"Search Baidu",@"Search Google",@"Search Wikipedia",@"Search Bing"];
    [searchBar setPlaceholder:[array objectAtIndex:searchBar.tag]];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    justNow = searchPages.currentPage;
    int nowPage = (scrollview.contentOffset.x+self.view.frame.size.width/2) / self.view.frame.size.width;//通过滚动的偏移量来判断目前页面所对应的小白点
    if (nowPage != justNow)
    {
        //如果可以已知tag通过UISearchBar的对象方法访问实例  该块代码需要重写
        //可以了  用指针
        [activeBar resignFirstResponder];
        [activeBar setShowsCancelButton:NO animated:YES];
        UITextField *searchField;
        for(id view in activeBar.subviews)
        {
            if([view isKindOfClass:[UITextField class]])
            {
                searchField = view;
                break;
            }
        }
        [searchField setText:@""];
        activeBar = nil;
    }
    if (scrollview.contentOffset.x>_view.frame.size.width*3)
    {
        //[self moveToLeft];
    }
    
    searchPages.currentPage = nowPage;//pagecontroll响应值的变化
    
}


+ (BOOL)isChromeAppInstalled {
    
    NSString *const ChromeSchemeHTTP = @"googlechrome";
    UIApplication *sb = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://", ChromeSchemeHTTP]];
    return [sb canOpenURL:url];
}






- (void) searchBarSearchButtonClicked:(UISearchBar *)aSearchBar{   //搜索按钮按下后的事件//
    
    
    
    
    
    if ( aSearchBar.tag == 0) {
        urlString = [NSString stringWithFormat:@"%@://www.baidu.com/s?wd=%@",browser,searchTerms];
        
    }
    else if (aSearchBar.tag == 1){
        
        
        urlString = [NSString stringWithFormat:@"%@://www.google.%@/search?q=%@&ie=UTF-8&oe=UTF-8&hl=%@&client=safari",browser,topLevelDomain,searchTerms,languageCode];
        
        
        
    }
    else if (aSearchBar.tag ==2){
        
        
        urlString = [NSString stringWithFormat:@"%@://%@.m.wikipedia.org/w/index.php?search=%@",browser,languageCodeShort,searchTerms];
        
        
        
    }
    else if ( aSearchBar .tag == 3){
        urlString = [NSString stringWithFormat:@"%@://www.bing.com/search?q=%@",browser,searchTerms];
    }
    
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL,  kCFStringEncodingUTF8 ));
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodedString]];
    
    //[aSearchBar setText:@""];
    [aSearchBar setShowsCancelButton:NO animated:YES];
    [aSearchBar resignFirstResponder];
    activeBar = nil;
    
}

//点击小圆点
- (void)changePage:(UIPageControl *)page{
    [scrollview setContentOffset:CGPointMake(self.view.frame.size.width * page.currentPage, 0)];
    
    [activeBar resignFirstResponder];
    [activeBar setShowsCancelButton:NO animated:YES];
    activeBar = nil;
}









//-------------------------------------------------------------------------------
//按下BookMark后会发生的事情

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    //[self showPicker];
    
    UIPasteboard *urlPaste = [UIPasteboard generalPasteboard];
    urlString = urlPaste.string;
    
    
    if ( YES ) {
        [self showCoolAlert:@"YES"];
    }
    else{
        //[self showCoolAlert:NO];
    }
    
    
    
    
}


//id observer1,observer2,observer3,observer4;

- (void)showCoolAlert:(NSString *)option{
    
    if ( [option isEqualToString:@"YES"] ) {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:@"Would you like to use TinEye Search By Image with the image link in your pasteboard?"];
        [alertView addButtonWithTitle:@"Cancel"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alertView) {
                                  
                                  //NSLog(@"Cancel Clicked");
                              }];
        [alertView addButtonWithTitle:@"OK"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  
                                  urlString = [NSString stringWithFormat:@"%@://www.tineye.com/search/?url=%@",browser,urlString];
                                  NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL,  kCFStringEncodingUTF8 ));
                                  
                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodedString]];
                                  
                              }];
        alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
        alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
        
        
        [alertView show];
        
    }
    
    else if ( [option isEqualToString:@"first"] ){
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Welcome!" andMessage:@"NCSearch makes it easier to search the web.If you have an available image link in your pasteborad,a bookmark button will appear and just press it to search by image with TinEye."];
        /*[alertView addButtonWithTitle:@"Cancel"
         type:SIAlertViewButtonTypeCancel
         handler:^(SIAlertView *alertView) {
         NSLog(@"Cancel Clicked");
         }];*/
        [alertView addButtonWithTitle:@"OK"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  
                              }];
        alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
        alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
        
        [alertView show];
        
        
    }
    
    /*observer1 = [[NSNotificationCenter defaultCenter] addObserverForName:SIAlertViewWillShowNotification
     object:alertView
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *note) {
     NSLog(@"%@, -willShowHandler3", alertView);
     }];
     observer2 =[[NSNotificationCenter defaultCenter] addObserverForName:SIAlertViewDidShowNotification
     object:alertView
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *note) {
     NSLog(@"%@, -didShowHandler3", alertView);
     }];
     observer3 =[[NSNotificationCenter defaultCenter] addObserverForName:SIAlertViewWillDismissNotification
     object:alertView
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *note) {
     NSLog(@"%@, -willDismissHandler3", alertView);
     }];
     observer4 =[[NSNotificationCenter defaultCenter] addObserverForName:SIAlertViewDidDismissNotification
     object:alertView
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *note) {
     NSLog(@"%@, -didDismissHandler3", alertView);
     
     [[NSNotificationCenter defaultCenter] removeObserver:observer1];
     [[NSNotificationCenter defaultCenter] removeObserver:observer2];
     [[NSNotificationCenter defaultCenter] removeObserver:observer3];
     [[NSNotificationCenter defaultCenter] removeObserver:observer4];
     
     observer1 = observer2 = observer3 = observer4 = nil;
     }];*/
    
    
    
}



/*- (void)showPicker{
 myPicker = [[UIImagePickerController alloc]init];
 myPicker.contentSizeForViewInPopover = CGSizeMake(300, 400);
 myPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
 myPicker.allowsEditing=YES;
 myPicker.delegate =self;
 
 self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
 self.window.backgroundColor = [UIColor clearColor];
 self.window.windowLevel = UIWindowLevelAlert;
 [self.window makeKeyAndVisible];
 newViewCon = [[UIViewController alloc] init];
 //newViewCon.view.frame = CGRectMake(0, 0, 320, 320);
 
 [self.window addSubview:newViewCon.view];
 //[self showCoolAlert];
 
 
 if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
 
 imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:myPicker];
 [imagePickerPopover setPopoverContentSize:CGSizeMake(300, 400)];
 imagePickerPopover.delegate = self;
 
 
 
 
 [imagePickerPopover presentPopoverFromRect:CGRectMake(100, 100, 300, 400) inView:newViewCon.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
 
 }
 else{
 
 
 [newViewCon presentViewController:myPicker animated:YES completion:^(void){}];
 }
 }*/



/*- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
 //window = nil;
 }*/








//___________________----------------------______________________
//呜呜哈哇啊下面是搜图的代码

/*- (void)imagePickerController: (UIImagePickerController *)picker
 didFinishPickingMediaWithInfo: (NSDictionary *)info{
 NSString *searchPicStr = [[NSString alloc] initWithFormat:@"http://www.google.com/searchbyimage?image_url="];
 
 //searchPicStr a
 UIImage* image = [info objectForKey: @"UIImagePickerControllerEditedImage"];
 NSData *searchPic = UIImageJPEGRepresentation(image, 1.0);
 
 [searchPic writeToFile:@"/a.jpge" atomically:YES];
 
 UIImageView *imView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 320, 300)];
 [imView setImage:image];
 [window addSubview:imView];
 [picker dismissViewControllerAnimated:YES completion:^(void){}];
 }*/














- (void) searchBarCancelButtonClicked:(UISearchBar *)aSearchBar{
    [aSearchBar setText:@""];
    [aSearchBar setShowsCancelButton:NO animated:YES];
    [aSearchBar resignFirstResponder];
}

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)



-(CGFloat)detectShowOrientation
{
    CGFloat tempWidth;
    tempWidth = [[UIScreen mainScreen] applicationFrame].size.width;
    return tempWidth;
}

- (void)didRotateFromInterfaceOrientation:(int)interfaceOrientation{
    
}

- (void)willRotateToInterfaceOrientation:(int)interfaceOrientation{
    // [self view];
    [self detectShowOrientation ];
}
/*- (void)willAnimateRotationToInterfaceOrientation:(int)interfaceOrientation{
 // [self view];
 [self detectShowOrientation ];
 }*/

- (void)viewWillAppear{
    /*
     manager.accelerometerUpdateInterval = 0.1; // 告诉manager，更新频率是100Hz
     [manager startAccelerometerUpdates];
     CMAccelerometerData *newestAccel = manager.accelerometerData;
     // x -> -1 proi
     // y -> -1 landspace
     
     if (newestAccel.acceleration.y < -1 && newestAccel.acceleration.y > -0.9) {
     _view.frame = CGRectMake(0, 0, [self detectShowOrientation], 71);
     
     [self showCoolAlert1:[NSString stringWithFormat:@"%f",[self detectShowOrientation]]];
     barView.frame = CGRectMake(0, 0, [self detectShowOrientation], 50);
     barViewGoogle.frame = CGRectMake([self detectShowOrientation], 0, [self detectShowOrientation], 50);
     barViewWiki.frame = CGRectMake([self detectShowOrientation]*2, 0, [self detectShowOrientation], 50);
     //scrollview.frame = CGRectMake(0, 0, [self detectShowOrientation], 50);
     mySearchBar.frame = CGRectMake(0, 0, [self detectShowOrientation], 41);
     mySearchBarGoogle.frame = CGRectMake(0, 0, [self detectShowOrientation], 41);
     mySearchBarWiki.frame = CGRectMake(0, 0, [self detectShowOrientation], 41);
     }if (newestAccel.acceleration.x < -1 && newestAccel.acceleration.x > -0.9) {
     _view.frame = CGRectMake(0, 0, [self detectShowOrientation], 71);
     [self showCoolAlert1:[NSString stringWithFormat:@"%f",[self detectShowOrientation]]];
     barView.frame = CGRectMake(0, 0, [self detectShowOrientation], 50);
     barViewGoogle.frame = CGRectMake([self detectShowOrientation], 0, [self detectShowOrientation], 50);
     barViewWiki.frame = CGRectMake([self detectShowOrientation]*2, 0, [self detectShowOrientation], 50);
     //scrollview.frame = CGRectMake(0, 0, [self detectShowOrientation], 50);
     mySearchBar.frame = CGRectMake(0, 0, [self detectShowOrientation], 41);
     mySearchBarGoogle.frame = CGRectMake(0, 0, [self detectShowOrientation], 41);
     mySearchBarWiki.frame = CGRectMake(0, 0, [self detectShowOrientation], 41);
     }
     */
    activeBar = nil;
    
    
    
    [searchBars removeAllObjects];
    NSDictionary *data;
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:kPrefs_Path1]) {
        searchBars = [[NSMutableArray alloc] initWithContentsOfFile:kPrefs_Path1];
    }else{
        //init AlertView
        searchBars = [[NSMutableArray alloc] init];
        data = [[NSDictionary alloc] initWithContentsOfFile:kPrefs_Path];
        
        if ([data valueForKey:@"searchPage1"]  == nil) {
            [searchBars addObject:@"Baidu"];
        }else{
            [searchBars addObject:[@[@"Baidu",@"Google",@"Wikipedia",@"Bing"] objectAtIndex:[[data valueForKey:@"searchPage1"] integerValue]]];
        }
        
        if ([data valueForKey:@"searchPage2"]  == nil) {
            [searchBars addObject:@"Google"];
        }else{
            [searchBars addObject:[@[@"Baidu",@"Google",@"Wikipedia",@"Bing"] objectAtIndex:[[data valueForKey:@"searchPage2"] integerValue]]];
        }
        
        if ([data valueForKey:@"searchPage3"]  == nil) {
            [searchBars addObject:@"Wikipedia"];
        }else{
            [searchBars addObject:[@[@"Baidu",@"Google",@"Wikipedia",@"Bing"] objectAtIndex:[[data valueForKey:@"searchPage3"] integerValue]]];
        }
        
        if ([data valueForKey:@"searchPage4"]  == nil) {
            [searchBars addObject:@"Bing"];
        }else{
            [searchBars addObject:[@[@"Baidu",@"Google",@"Wikipedia",@"Bing"] objectAtIndex:[[data valueForKey:@"searchPage4"] integerValue]]];
        }
    }
    [scrollview setContentOffset:CGPointMake(self.view.frame.size.width, 0)];
    scrollview.contentSize = CGSizeMake(self.view.frame.size.width*4, 50);
    
    
    [mySearchBar setTag:[self tagForString:[searchBars objectAtIndex:0]]];
    [mySearchBarGoogle setTag:[self tagForString:[searchBars objectAtIndex:1]]];
    [mySearchBarWiki setTag:[self tagForString:[searchBars objectAtIndex:2]]];
    [mySearchBarBing setTag:[self tagForString:[searchBars objectAtIndex:3]]];
    
    mySearchBarBing.placeholder=[@[@"Search Baidu",@"Search Google",@"Search Wikipedia",@"Search Bing"] objectAtIndex:mySearchBarBing.tag];
    mySearchBarWiki.placeholder=[@[@"Search Baidu",@"Search Google",@"Search Wikipedia",@"Search Bing"] objectAtIndex:mySearchBarWiki.tag];
    mySearchBarGoogle.placeholder=[@[@"Search Baidu",@"Search Google",@"Search Wikipedia",@"Search Bing"] objectAtIndex:mySearchBarGoogle.tag];
    mySearchBar.placeholder=[@[@"Search Baidu",@"Search Google",@"Search Wikipedia",@"Search Bing"] objectAtIndex:mySearchBar.tag];
    
    
    barView.frame = CGRectMake(0,0,self.view.frame.size.width,50);
    [barView setNeedsDisplay];
    mySearchBar.frame = CGRectMake(0,0,self.view.frame.size.width,50);
    [mySearchBar setNeedsDisplay];
    
    
    
    barViewGoogle.frame = CGRectMake(self.view.frame.size.width,0,self.view.frame.size.width,50);
    [barViewGoogle setNeedsDisplay];
    mySearchBarGoogle.frame = CGRectMake(0,0,self.view.frame.size.width,50);
    [mySearchBarGoogle setNeedsDisplay];
    
    
    
    barViewBing.frame = CGRectMake(self.view.frame.size.width*3, 0, self.view.frame.size.width, 50);
    [barViewBing setNeedsDisplay];
    mySearchBarBing.frame = CGRectMake(0,0,self.view.frame.size.width,50);
    [mySearchBarBing setNeedsDisplay];
    
    barViewWiki.frame = CGRectMake(self.view.frame.size.width*2, 0, self.view.frame.size.width, 50);
    [barViewWiki setNeedsDisplay];
    mySearchBarWiki.frame = CGRectMake(0,0,self.view.frame.size.width,50);
    [mySearchBarWiki setNeedsDisplay];
    

    //这里是检测是否第一次运行，但是不知为什么跪了
    
    
    
    
    
    //------------------------------^^^^^^^^^^^^^^^
    //  |||||||||||||||
    
    UIPasteboard *urlPaste = [UIPasteboard generalPasteboard];
    urlString = urlPaste.string;
    if ( [urlString hasPrefix:@"http"] ) {
        [mySearchBar setShowsBookmarkButton:YES];
        [mySearchBarGoogle setShowsBookmarkButton:YES];
        [mySearchBarWiki setShowsBookmarkButton:YES];
        [mySearchBarBing setShowsBookmarkButton:YES];
    }
    else {
        [mySearchBar setShowsBookmarkButton:NO];
        [mySearchBarGoogle setShowsBookmarkButton:NO];
        [mySearchBarWiki setShowsBookmarkButton:NO];
        [mySearchBarBing setShowsBookmarkButton:NO];
        
    }
    
    //NSDictionary *data1 = [[NSDictionary alloc] initWithContentsOfFile:kPrefs_Path];
    if ([data valueForKey:@"Browser"] == nil)
    {
        browser = @"http";
    }
    else if ( [[data valueForKey:@"Browser"] integerValue] == 1)
    {
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlechrome://www.google.com"]] == YES )
        {
            browser = @"googlechrome";
        }
        else
        {
            browser = @"http";
        }
    }
    else if ( [[data valueForKey:@"Browser"] integerValue] == 2 )
    {
        
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"ucweb://www.google.com"]] == YES )
        {
            browser  = @"ucweb";
        }
        else if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"ucbrowser://www.google.com"]] == YES )
        {
            browser = @"ucbrowser";
        }
        else
        {
            browser =@"http";
        }
    }
    else if ( [[data valueForKey:@"Browser"] integerValue] == 3 )
    {
       
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"ucbrowser://www.google.com"]] == YES )
        {
            browser = @"ucbrowser";
        }
        else if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"ucweb://www.google.com"]] == YES )
        {
            browser  = @"ucweb";
        }
        else
        {
            browser =@"http";
        }
    }
    else if ( [[data valueForKey:@"Browser"] integerValue] == 4 )
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"oftp://www.google.com"]] == YES) {
            browser = @"ohttp";
        }
        else
        {
            browser = @"http";
        }
    }
    else
    {
        browser = @"http";
    }
    
    if ( [[data valueForKey:@"Pages Dots"] integerValue] == 0 ) {
        [self.view addSubview:searchPages];
    }
    else {
        if ( [self.view.subviews containsObject:searchPages] ) {
            [searchPages removeFromSuperview];
        }
    }
}
+ (NSString *)language{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return preferredLang;
    
    
}
- (void)viewDidDisappear{
    
    
    
    
    
    [activeBar setShowsCancelButton:NO animated:NO];
    [activeBar setPlaceholder:[@[@"Search Baidu",@"Search Google",@"Search Wikipedia",@"Search Bing"] objectAtIndex:(activeBar).tag]];
    [activeBar setText:@""];
    activeBar = nil;
    
    
    
}

- (void)viewWillDisappear{
    
    //[self showCoolAlert:@"first"];
    
    
    
}




@end


