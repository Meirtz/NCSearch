//
//  NCSearchBar.m
//  NCSearch
//
//  Created by Meirtz on 13-7-27.
//
//

#import "NCSearchBar.h"
#import <QuartzCore/QuartzCore.h>
@implementation NCSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)layoutSubviews
{
    UITextField *searchField;
    
    for(id view in self.subviews)
    {
        if([view isKindOfClass:[UITextField class]])
        {
            searchField = view;
            break;
        }
    }
    
    if(!(searchField == nil))
    {
        CGRect rect = CGRectMake(0, 0, 1, 1);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextFillRect(context, rect);
        UIImage * bgImage = [[UIImage alloc] init];
        bgImage = UIGraphicsGetImageFromCurrentImageContext();
        
        searchField.background = bgImage;
        searchField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
        searchField.borderStyle = UITextBorderStyleNone;
        searchField.textColor = [UIColor whiteColor];
        [searchField setBackground:nil];
        [searchField setValue:[UIColor colorWithWhite:0.8 alpha:0.9] forKeyPath:@"_placeholderLabel.textColor"];
        [searchField setValue:[UIFont fontWithName:@"Helvetica" size:13.0] forKeyPath:@"_placeholderLabel.font"];
        [searchField setKeyboardAppearance:UIKeyboardAppearanceAlert];
        
        
        //边框
        searchField.layer.cornerRadius = 9;
        searchField.layer.borderWidth = 0.9;
        UIImageView *mirror = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [mirror setImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/NCSearch.bundle/mirror.png"]];
        searchField.leftView = mirror;
        searchField.layer.borderColor = [[UIColor colorWithRed:255 green:255 blue:255 alpha:0.38] CGColor];
        
        
        

        
        //阴影
    }
    
    
    
    [super layoutSubviews];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
