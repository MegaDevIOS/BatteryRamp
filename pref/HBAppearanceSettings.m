#import "RampRootListController.h"

@implementation HBAppearanceBo

-(UIColor *)tintColor {
    return [UIColor systemBlueColor];
}

-(UIColor *)statusBarTintColor {
    return [UIColor systemBlueColor];
}

-(UIColor *)navigationBarTitleColor {
    return [UIColor whiteColor];
}

-(UIColor *)navigationBarTintColor {
    return [UIColor whiteColor];
}

-(UIColor *)tableViewCellSeparatorColor {
    return [UIColor colorWithWhite:0 alpha:0];
}

-(UIColor *)navigationBarBackgroundColor {
    return [UIColor systemBlueColor];
}

-(BOOL)translucentNavigationBar {
    return YES;
}

@end
