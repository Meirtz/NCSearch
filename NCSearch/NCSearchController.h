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

@interface NCSearchController : NSObject <BBWeeAppController>
{
    UIView *_view;
}

- (UIView *)view;

@end