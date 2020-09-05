#include "RampRootListController.h"
#import <Preferences/PSEditableTableCell.h>
#import <Cephei/HBPreferences.h>
#define StartRampMode "com.megadev.batteryramp/StartRampMode"
#define initSaveMode @"com.megadev.batteryramp/initSaveMode"
    #import <sys/utsname.h> 
    NSString* deviceName()
    {
        struct utsname systemInfo;
        uname(&systemInfo);

        return [NSString stringWithCString:systemInfo.machine
                                  encoding:NSUTF8StringEncoding];
    }


@implementation RampRootListController

-(instancetype)init {
self = [super init];

if (self) {
HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
appearanceSettings.tintColor = [UIColor systemBlueColor];
appearanceSettings.tableViewCellSeparatorColor = [UIColor colorWithWhite:0 alpha:0];
self.hb_appearanceSettings = appearanceSettings;
self.respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring"
style:UIBarButtonItemStylePlain
target:self
action:@selector(respring:)];
self.respringButton.tintColor = [UIColor systemBlueColor];
self.navigationItem.rightBarButtonItem = self.respringButton;




}

return self;
}

-(NSArray *)specifiers {
if (_specifiers == nil) {
_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
}

return _specifiers;
}


- (void)respring:(id)sender {
NSTask *t = [[[NSTask alloc] init] autorelease];
[t setLaunchPath:@"/usr/bin/killall"];
[t setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
[t launch];
}


-(void)triggerramp{
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)initSaveMode, nil, nil, true);
}

@end







@interface MegaSupportCell : PSEditableTableCell
@end

@implementation MegaSupportCell
-(id)initWithStyle:(long long)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3 {
self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
if (self) {
UITextField* textField = [self textField];
textField.textAlignment = NSTextAlignmentLeft;
textField.delegate = self;
NSString *genuine;
    if (![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.megadev.batteryramp.list"]){
        genuine = @"0";

    }else{
        genuine = @"1";
    }
NSString *supportkey = [NSString stringWithFormat:@"v%@p%@g%@",[[UIDevice currentDevice] systemVersion],deviceName(),genuine];
 NSString *supportkeyc = [supportkey stringByReplacingOccurrencesOfString:@"," withString:@"."];
 NSString *supportkeycc = [supportkeyc capitalizedString];
 NSString *supportkeyccc = [supportkeycc stringByReplacingOccurrencesOfString:@"iphone" withString:@""];
textField.text = supportkeyccc;
  textField.inputView = [[UIView alloc] initWithFrame:CGRectZero];


}
return self;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
}

@end
