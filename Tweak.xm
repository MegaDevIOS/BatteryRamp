#import <Foundation/Foundation.h>

#import <Cephei/HBPreferences.h>
#import "QuartzCore/QuartzCore.h"
#import <UIKit/UIKit.h>
#import "MediaRemote.h"
  #import "NSTask.h"
#include <stdio.h>
#include <stdlib.h>
#include <mach/mach.h>
#include <CoreFoundation/CoreFoundation.h>
#include <IOKit/IOKitLib.h>
#include <IOKit/pwr_mgt/IOPMLib.h>
#import <UIKit/UIWindow+Private.h>
#define ChargingPopup @"com.megadev.batteryramp/popup"
#define uupdatebatteryramp @"com.megadev.batteryramp/uupdatebatteryramp"
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#import "BatRampMenu.h"
BOOL SaverMode = NO;
HBPreferences *pfs;
NSString *fadeouttime = @"2.0";
BOOL enable;
BOOL showclock;
BOOL enablehibernation;
UIWindow *rootwindow = nil;
UIView *LockDateView;

   UILabel *batterytext;

NSString *IsHibre = @"";

int pressed = 0;
NSUserDefaults *def = [[NSUserDefaults alloc] initWithSuiteName:@"com.megadev.batteryramp"];





bool popupshown = NO;


@interface SBAppLayout:NSObject
@property (nonatomic,copy) NSDictionary * rolesToLayoutItemsMap;                                         //@synthesize rolesToLayoutItemsMap=_rolesToLayoutItemsMap - In the implementation block
@end

@interface SBRecentAppLayouts: NSObject
+ (id)sharedInstance;
-(id)_recentsFromPrefs;
-(void)remove:(SBAppLayout* )arg1;
-(void)removeAppLayouts:(id)arg1 ;
@end
@interface SBMainSwitcherViewController: UIViewController
+ (id)sharedInstance;
-(id)recentAppLayouts;
-(void)_rebuildAppListCache;
-(void)_destroyAppListCache;
-(void)_removeCardForDisplayIdentifier:(id)arg1 ;
-(void)_deleteAppLayout:(id)arg1 forReason:(long long)arg2;
@end
@interface SBFLockScreenDateView 

-(void)setDate:(NSDate *)arg1;
@end
@interface _CDBatterySaver

-(id)batterySaver;
-(long long)getPowerMode;
-(BOOL)setPowerMode:(long long)arg1 error:(id *)arg2;

@end

@interface SBSleepWakeHardwareButtonInteraction
-(void)_performSleep;
-(void)_performWake;
@end

@interface SpringBoard
-(void)_simulateLockButtonPress;
@property (nonatomic,retain) BatRampMenu *batterypopup;
@property (nonatomic,retain) BatRampMenu12 *batterypopup12;
@property (nonatomic,retain) UIView *popupbg;
@property (nonatomic,retain) UILabel *hibernationtext;
@property (nonatomic,retain) UIView *clockbox;
@property (nonatomic,retain) UILabel *batterytext;
@property (nonatomic,retain) UILabel *exitlabel;
@property (nonatomic,retain) UIView *view1;
@property (nonatomic,retain) UIView *view2;
@property (nonatomic,retain) UIView *view3;
@property (nonatomic,retain) UIView *view4;
@property (nonatomic,retain) UIView *view5;
@property (nonatomic,retain) UIView *panframe;
-(void)_updateRingerState:(int)arg1 withVisuals:(BOOL)arg2 updatePreferenceRegister:(BOOL)arg3 ;


@end 


@interface SBBrightnessController
-(id)sharedBrightnessController;
-(void)setBrightnessLevel:(float)arg1 ;
@end
@interface SBLockScreenManager
+(id)sharedInstance;
-(void)setBiometricAutoUnlockingDisabled:(BOOL)arg1 forReason:(id)arg2 ;
 -(_Bool)unlockUIFromSource:(int)arg1 withOptions:(id)arg2;

@end
@interface SBAirplaneModeController

+(id)sharedInstance;
-(BOOL)isInAirplaneMode;
-(void)setInAirplaneMode:(BOOL)arg1 ;
@end
@interface UIRootSceneWindow
-(void)setFrame:(CGRect)arg1 ;

@end
@interface FBRootWindow
-(id)initWithDisplayConfiguration:(id)arg1;

@end
bool start = YES;



%group iOS13 
%hook SBUIController







-(void)ACPowerChanged{
[[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];



if(start){



if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging) {
   [[NSNotificationCenter defaultCenter] postNotificationName:@"ChargingPopup" object:nil userInfo:nil];
}
		start = NO;





	
   
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

start = YES;
		     });


              if(SaverMode){

     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

 if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateUnplugged) {

   NSTask *t = [[NSTask alloc] init];
[t setLaunchPath:@"/usr/bin/killall"];
[t setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
[t launch];
     SaverMode = NO;


        }


    });

   }
  
}








if(popupshown){
	   [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveChargePopup" object:nil userInfo:nil];
	   popupshown = NO;
}


 return %orig;
}




%end


%hook UIRootSceneWindow

-(void)setFrame:(CGRect)arg1{
	  rootwindow = (UIWindow *)self;

	  return %orig;
}

%end


%hook SBSleepWakeHardwareButtonInteraction

-(void)_performWake{
%orig;
if(SaverMode){


      [[NSNotificationCenter defaultCenter] postNotificationName:@"uupdatebatteryramp" object:nil userInfo:nil];
		 
		     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, [fadeouttime floatValue]  * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
              
  [(SpringBoard *)[%c(SpringBoard) sharedApplication] _simulateLockButtonPress];

  if(enablehibernation){
  
  }


		     });


			 

}

}


%end

%hook SpringBoard
%property (nonatomic,retain) BatRampMenu *batterypopup;
%property (nonatomic,retain) UIView *popupbg;
%property (nonatomic,retain) UIView *clockbox;

%property (nonatomic,retain) UIView *panframe;
%property (nonatomic,retain) UILabel *batterytext;
%property (nonatomic,retain) UILabel *hibernationtext;
%property (nonatomic,retain) UILabel *exitlabel;
%property (nonatomic,retain) UIView *view1;
%property (nonatomic,retain) UIView *view2;
%property (nonatomic,retain) UIView *view3;
%property (nonatomic,retain) UIView *view4;
%property (nonatomic,retain) UIView *view5;

-(_Bool)_handlePhysicalButtonEvent:(UIPressesEvent *)arg1 {

if(SaverMode){


  for(UIPress* press in arg1.allPresses.allObjects) {
      if (press.type == 102 && press.force == 1) {
   
     pressed += 1;

if(pressed == 3){
   NSTask *t = [[NSTask alloc] init];
[t setLaunchPath:@"/usr/bin/killall"];
[t setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
[t launch];

SaverMode = NO;

}


      }else{
	return %orig;
	  }

  }
  int type = arg1.allPresses.allObjects[0].type;
  int force = arg1.allPresses.allObjects[0].force;



}else{
		return %orig;
}


}
-(void)applicationDidFinishLaunching:(id)arg1 {

%orig;

    if (![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.megadev.batteryramp.list"]){

   
    UIAlertController * alert = [UIAlertController
                alertControllerWithTitle:@"Major error"
                                 message:@"Y04 D1R7Y P2R6T3"
                          preferredStyle:UIAlertControllerStyleAlert];



UIAlertAction* yesButton = [UIAlertAction
                    actionWithTitle:@"Ok"
                              style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action) {
                     
NSString *Name = @"I26Ql-uX6AM";

NSURL *linkToApp = [NSURL URLWithString:[NSString stringWithFormat:@"youtube://watch?v=%@",Name]]; // I dont know excatly this one 
NSURL *linkToWeb = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@",Name]]; // this is correct


if ([[UIApplication sharedApplication] canOpenURL:linkToApp]) {
         [[objc_getClass("SBLockScreenManager") sharedInstance] unlockUIFromSource:17 withOptions:nil];

      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

 [[UIApplication sharedApplication] openURL:linkToApp];
		     });
    // Can open the youtube app URL so launch the youTube app with this URL

   
    
}
else{
    // Can't open the youtube app URL so launch Safari instead
    [[objc_getClass("SBLockScreenManager") sharedInstance] unlockUIFromSource:17 withOptions:nil];
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

 [[UIApplication sharedApplication] openURL:linkToApp];
		     });
      
}
                            }];


[alert addAction:yesButton];


[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
	



    }


if(SaverMode){
   SaverMode = NO;
   pressed = 0;
}

BOOL restoreAfterSave = [[def objectForKey:@"didSaveModeActivate"]boolValue];
BOOL lpmAfterSave = [[def objectForKey:@"isPowerModeActive"]boolValue];
BOOL airplaneafterSave = [[def objectForKey:@"isAirplaneActive"]boolValue];
float brightnessset = [def floatForKey:@"oldbrightness"];

if(restoreAfterSave){


[def setValue:NO forKey:@"didSaveModeActivate"];
		    
  [[objc_getClass("_CDBatterySaver") batterySaver] setPowerMode:lpmAfterSave error:nil];

[[%c(SBAirplaneModeController) sharedInstance] setInAirplaneMode:airplaneafterSave];



[[%c(SBBrightnessController) sharedBrightnessController] setBrightnessLevel:brightnessset];


}


    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(giveChargingPopup:) 
        name:@"ChargingPopup"
        object:nil];

		    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(removechargepopup:) 
        name:@"RemoveChargePopup"
        object:nil];


				    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(startrampmode:) 
        name:@"StartRampMode"
        object:nil];

						    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(updatebatteryramp:) 
        name:@"uupdatebatteryramp"
        object:nil];



}
%new
- (void) giveChargingPopup:(NSNotification *) notification{

   self.popupbg = [[UIView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)];
   self.popupbg.backgroundColor = [UIColor colorWithRed: 0.00 green: 0.00 blue: 0.00 alpha: 0.65];





   UITapGestureRecognizer *singleFingerTap = 
  [[UITapGestureRecognizer alloc] initWithTarget:self 
                                          action:@selector(removechargepopup:)];
[self.popupbg addGestureRecognizer:singleFingerTap];

    self.batterypopup = [[BatRampMenu alloc] initWithFrame:CGRectMake(0,[[UIScreen mainScreen] bounds].size.height + 400 ,[[UIScreen mainScreen] bounds].size.width - 10,360)];
    
    
    [self.batterypopup setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup.frame.origin.y + 173)];
    
 
    
    if([[UIScreen mainScreen] bounds].size.height < 700){
        self.batterypopup.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height + 400 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
           [self.batterypopup setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup.frame.origin.y + 145)];
     }
    
    if([[UIScreen mainScreen] bounds].size.height < 740 && [[UIScreen mainScreen] bounds].size.height > 700){
        self.batterypopup.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height + 400 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
           [self.batterypopup setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup.frame.origin.y + 145)];
     }
    


[UIView animateWithDuration:0.6
                         delay:0
						 usingSpringWithDamping:1
						 initialSpringVelocity:0.3
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                         
         self.batterypopup.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 360 ,[[UIScreen mainScreen] bounds].size.width - 10,360);
        
              [self.batterypopup setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup.frame.origin.y + 173)];
        

        if([[UIScreen mainScreen] bounds].size.height < 700){
            self.batterypopup.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 300 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
               [self.batterypopup setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup.frame.origin.y + 145)];
         }
        
        if([[UIScreen mainScreen] bounds].size.height < 740 && [[UIScreen mainScreen] bounds].size.height > 700){
            self.batterypopup.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 300 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
               [self.batterypopup setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup.frame.origin.y + 145)];
         }
                                    }
                        completion:nil];
    
self.panframe = [[UIView alloc] initWithFrame:CGRectMake(0,[[UIScreen mainScreen] bounds].size.height + 400 ,[[UIScreen mainScreen] bounds].size.width - 10,360)];
    

    [self.panframe setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup.frame.origin.y + 173)];
    

         self.panframe.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 360 ,[[UIScreen mainScreen] bounds].size.width - 10,360);
        
              [self.panframe setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup.frame.origin.y + 173)];
        

        if([[UIScreen mainScreen] bounds].size.height < 700){
            self.panframe.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 300 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
               [self.panframe setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup.frame.origin.y + 145)];
         }
        
        if([[UIScreen mainScreen] bounds].size.height < 740 && [[UIScreen mainScreen] bounds].size.height > 700){
            self.panframe.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 300 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
               [self.panframe setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup.frame.origin.y + 145)];
         }

        if([[UIScreen mainScreen] bounds].size.width > 420) {


           
            self.batterypopup.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 300 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
               [self.batterypopup setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup.frame.origin.y + 145)];
         }



	  [rootwindow addSubview:self.panframe];
	  [rootwindow addSubview:self.popupbg];


	   [self.popupbg setAlpha:0.f];
	  [UIView animateWithDuration:0.2
                         delay:0
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{
                                  [self.popupbg setAlpha:1.f];
                                } 
                    completion:nil];


	  [rootwindow addSubview:self.batterypopup];

      UIPanGestureRecognizer *panGestureRecognizer;
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragPopup:)];
        panGestureRecognizer.cancelsTouchesInView = NO;


 
        [self.batterypopup addGestureRecognizer:panGestureRecognizer];


/*	  UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(removechargepopup:)];
[swipeDown setDirection:UISwipeGestureRecognizerDirectionDown ];
[self.batterypopup addGestureRecognizer:swipeDown];*/
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

popupshown = YES;
		     });


///AudioServicesPlaySystemSound(1521);




}


%new
//// Move handler
- (void)dragPopup:(UIPanGestureRecognizer *)recognizer {

CGPoint vel = [recognizer velocityInView:self.panframe];

         CGPoint translation = [recognizer translationInView:self.panframe];

    recognizer.view.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2,
                                         recognizer.view.center.y + translation.y);





    [recognizer setTranslation:CGPointMake([[UIScreen mainScreen] bounds].size.width/2, 0) inView:self.panframe];




    
   if(self.batterypopup.center.y < [[UIScreen mainScreen] bounds].size.height-360){
	   [UIView animateWithDuration:0.6
                         delay:0
						 usingSpringWithDamping:1
						 initialSpringVelocity:0.3
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                         
         self.batterypopup.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 360 ,[[UIScreen mainScreen] bounds].size.width - 10,360);
        
              [self.batterypopup setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup.frame.origin.y + 173)];
        

        if([[UIScreen mainScreen] bounds].size.height < 700){
            self.batterypopup.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 300 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
               [self.batterypopup setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup.frame.origin.y + 145)];
         }
        
        if([[UIScreen mainScreen] bounds].size.height < 740 && [[UIScreen mainScreen] bounds].size.height > 700){
            self.batterypopup.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 300 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
               [self.batterypopup setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup.frame.origin.y + 145)];
         }
                                    }
                        completion:nil];
 }
      
       if(self.batterypopup.center.y > [[UIScreen mainScreen] bounds].size.height-50){
[[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveChargePopup" object:nil userInfo:nil];
	   }else{

		       if (recognizer.state == UIGestureRecognizerStateEnded) {
  [UIView animateWithDuration:0.6
                         delay:0
						 usingSpringWithDamping:1
						 initialSpringVelocity:0.3
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                         
         self.batterypopup.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 360 ,[[UIScreen mainScreen] bounds].size.width - 10,360);
        
              [self.batterypopup setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup.frame.origin.y + 173)];
        

        if([[UIScreen mainScreen] bounds].size.height < 700){
            self.batterypopup.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 300 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
               [self.batterypopup setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup.frame.origin.y + 145)];
         }
        
        if([[UIScreen mainScreen] bounds].size.height < 740 && [[UIScreen mainScreen] bounds].size.height > 700){
            self.batterypopup.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 300 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
               [self.batterypopup setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup.frame.origin.y + 145)];
         }
                                    }
                        completion:nil];
	   }


  
    }

     }













%new
- (void) startrampmode:(NSNotification *) notification{
	SaverMode = YES;
   
	[self.batterypopup removeFromSuperview];

   
float brightnessOLD = [[UIScreen mainScreen] brightness];

BOOL powermode = [[objc_getClass("_CDBatterySaver") batterySaver] getPowerMode];
BOOL Airplane = [[%c(SBAirplaneModeController) sharedInstance] isInAirplaneMode];

[def setFloat:brightnessOLD forKey:@"oldbrightness"];
[def setValue:@(SaverMode) forKey:@"didSaveModeActivate"];
[def setValue:@(powermode) forKey:@"isPowerModeActive"];
[def setValue:@(Airplane) forKey:@"isAirplaneActive"];
[def synchronize];


  [(SpringBoard *)[%c(SpringBoard) sharedApplication] _simulateLockButtonPress];


  [(SpringBoard *)[%c(SpringBoard) sharedApplication] _updateRingerState:0 withVisuals:NO updatePreferenceRegister:NO];
  [[objc_getClass("_CDBatterySaver") batterySaver] setPowerMode:1 error:nil];






[[%c(SBBrightnessController) sharedBrightnessController] setBrightnessLevel: 0];
 MRMediaRemoteSendCommand(kMRPause, nil);

[[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
[[UIDevice currentDevice] proximityState];


SBLockScreenManager *sensor = [%c(SBLockScreenManager) sharedInstance];
  [sensor setBiometricAutoUnlockingDisabled:YES forReason:@"com.megadev.batteryramp"];

[[%c(SBAirplaneModeController) sharedInstance] setInAirplaneMode:YES];




		 

    


UIView *window1 = [[UIView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)];
window1.backgroundColor = [UIColor blackColor];


[rootwindow addSubview:window1];
[window1 setAlpha:0.f];

[UIView animateWithDuration:0.2
                         delay:0
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{
                                  [window1 setAlpha:1.f];
                                } 
                    completion:nil];


                    NSData *data;
  if(enablehibernation){
    NSTask *task = [[NSTask alloc] init];
[task setLaunchPath:@"/usr/bin/librampdeepsleep"];
[task setArguments:@[ @""]];
NSPipe *pipe = [NSPipe pipe];
[task setStandardOutput: pipe];
NSFileHandle *file = [pipe fileHandleForReading];
    
[task launch];
    
data = [file readDataToEndOfFile];


IsHibre = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] ;
  }




       self.batterytext = [[UILabel alloc] initWithFrame:CGRectZero];
         self.batterytext.backgroundColor = [UIColor clearColor];

  

    
    [    self.batterytext setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width/ 2, [[UIScreen mainScreen] bounds].size.height/ 2)];
    
    
         self.batterytext.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height/ 2.3,[[UIScreen mainScreen] bounds].size.width,40);
   
         self.batterytext.textAlignment = NSTextAlignmentCenter;
         self.batterytext.textColor = [UIColor whiteColor];
      [self.batterytext setFont:[UIFont boldSystemFontOfSize:10]];
UIDevice *myDevice = [UIDevice currentDevice];    
[myDevice setBatteryMonitoringEnabled:YES];

double batLeft = (float)[myDevice batteryLevel] * 100;
NSLog(@"%.f", batLeft);    

NSString * levelLabel = [NSString stringWithFormat:@"%.f%%", batLeft];    

         self.batterytext.text = levelLabel;
        
    //View 1
     self.view1 = [[UIView alloc] init];
       self.view1.backgroundColor =  [UIColor systemGrayColor];
   self.view1.layer.cornerRadius = 5;
       [self.view1.heightAnchor constraintEqualToConstant:10].active = true;
       [self.view1.widthAnchor constraintEqualToConstant:10].active = true;


       //View 2
       self.view2 = [[UIView alloc] init];
       self.view2.backgroundColor =  [UIColor systemGrayColor];
        self.view2.layer.cornerRadius = 5;
       [self.view2.heightAnchor constraintEqualToConstant:10].active = true;
       [self.view2.widthAnchor constraintEqualToConstant:10].active = true;

       //View 3
       self.view3 = [[UIView alloc] init];
       self.view3 .backgroundColor =  [UIColor systemGrayColor];
        self.view3 .layer.cornerRadius = 5;
       [self.view3 .heightAnchor constraintEqualToConstant:10].active = true;
       [self.view3 .widthAnchor constraintEqualToConstant:10].active = true;
    
    
    //View 4
    self.view4 = [[UIView alloc] init];
     self.view4.backgroundColor =  [UIColor systemGrayColor];
      self.view4.layer.cornerRadius = 5;
    [ self.view4.heightAnchor constraintEqualToConstant:10].active = true;
    [ self.view4.widthAnchor constraintEqualToConstant:10].active = true;
    
    
    //View 5
    self.view5 = [[UIView alloc] init];
    self.view5.backgroundColor = [UIColor systemGrayColor];
     self.view5.layer.cornerRadius = 5;
    [self.view5.heightAnchor constraintEqualToConstant:10].active = true;
    [self.view5.widthAnchor constraintEqualToConstant:10].active = true;

       //Stack View
       UIStackView *stackView = [[UIStackView alloc] init];

       stackView.spacing = 15;

       stackView.axis = UILayoutConstraintAxisHorizontal;
       stackView.distribution = UIStackViewDistributionEqualSpacing;
       stackView.alignment = UIStackViewAlignmentCenter;
       stackView.spacing = 30;


       [stackView addArrangedSubview:self.view1];
       [stackView addArrangedSubview:self.view2];
       [stackView addArrangedSubview:self.view3];
           [stackView addArrangedSubview:self.view4];
           [stackView addArrangedSubview:self.view5];

       stackView.translatesAutoresizingMaskIntoConstraints = false;
       [window1 addSubview:stackView];


       //Layout for Stack View
       [stackView.centerXAnchor constraintEqualToAnchor:window1.centerXAnchor].active = true;
       [stackView.centerYAnchor constraintEqualToAnchor:window1.centerYAnchor].active = true;


	     [window1 addSubview:self.batterytext];


        self.hibernationtext = [[UILabel alloc] init];
        self.hibernationtext.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height/1.2,[[UIScreen mainScreen] bounds].size.width,60);
        self.hibernationtext.text = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
         self.hibernationtext.textAlignment = NSTextAlignmentCenter;
         self.hibernationtext.textColor = [UIColor whiteColor];
      [self.hibernationtext setFont:[UIFont systemFontOfSize:13]];


        [window1 addSubview:self.hibernationtext];


       self.exitlabel = [[UILabel alloc] initWithFrame:CGRectZero];
       self.exitlabel.backgroundColor = [UIColor clearColor];

    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(-20, 15, 5,70)];
    
    line.backgroundColor = [UIColor whiteColor];
    line.layer.cornerRadius = 1;
    [self.exitlabel addSubview:line];
      

      
      
       self.exitlabel.frame = CGRectMake(20,145,[[UIScreen mainScreen] bounds].size.width,100);
     
    
    if([[UIScreen mainScreen] bounds].size.height < 740){
           self.exitlabel.frame = CGRectMake(20,50,[[UIScreen mainScreen] bounds].size.width,100);
        
   
        
    }
       self.exitlabel.textAlignment = NSTextAlignmentLeft;
       self.exitlabel.textColor = [UIColor whiteColor];
    self.exitlabel.numberOfLines = 2;

       self.exitlabel.text = @"Triple Click\nVolume Up to Exit";
	   

if(batLeft > 0){
	self.view1.backgroundColor = [UIColor greenColor];
}

if(batLeft > 20){
self.view2.backgroundColor = [UIColor greenColor];
}



if(batLeft > 40){
self.view3.backgroundColor = [UIColor greenColor];
}

if(batLeft > 60){
self.view4.backgroundColor = [UIColor greenColor];
}

if(batLeft > 80){
self.view5.backgroundColor = [UIColor greenColor];
}

if(batLeft > 80){
self.view5.backgroundColor = [UIColor greenColor];
}
    
    [window1 addSubview:self.exitlabel];

self.clockbox = [[UIView alloc] init];
self.clockbox.frame = CGRectMake(0,80,[[UIScreen mainScreen] bounds].size.width,200);

if(showclock){
[window1 addSubview:self.clockbox];


[self.clockbox addSubview:LockDateView];


}






}
%new
- (void) removechargepopup:(NSNotification *) notification{




	   [self.popupbg setAlpha:1.f];
	  [UIView animateWithDuration:0.2
                         delay:0
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{
                                  [self.popupbg setAlpha:0.f];
                                } 
                        completion:^(BOOL finished) {
       [self.popupbg removeFromSuperview];
    }

						];
 
      [self.panframe removeFromSuperview];
[UIView animateWithDuration:0.6
                         delay:0
						 usingSpringWithDamping:1
						 initialSpringVelocity:0.3
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                         
         self.batterypopup.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height + 400 ,[[UIScreen mainScreen] bounds].size.width - 10,360);
        
              [self.batterypopup setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup.frame.origin.y + 173)];
        

        if([[UIScreen mainScreen] bounds].size.height < 700){
            self.batterypopup.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height + 400 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
               [self.batterypopup setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup.frame.origin.y + 145)];
         }
        
        if([[UIScreen mainScreen] bounds].size.height < 740 && [[UIScreen mainScreen] bounds].size.height > 700){
            self.batterypopup.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height +400 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
               [self.batterypopup setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup.frame.origin.y + 145)];
         }
                                    }
                        completion:^(BOOL finished) {
      [self.batterypopup removeFromSuperview];
    }

						];
    





}

%new
- (void) updatebatteryramp:(NSNotification *) notification{
UIDevice *myDevice = [UIDevice currentDevice];    
[myDevice setBatteryMonitoringEnabled:YES];

double batLeft = (float)[myDevice batteryLevel] * 100;
	[self.exitlabel setAlpha:1.f];
   if(LockDateView){
   [self.clockbox setAlpha:0.f];
   }


[UIView animateWithDuration:0.5
                         delay:1
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{
                                  [self.exitlabel setAlpha:0.f];
                                     if(LockDateView){
                                  [self.clockbox setAlpha:1.f];
                                     }
                                     
                                } 
                    completion:nil];
NSString * levelLabel = [NSString stringWithFormat:@"%.f%%", batLeft];    

         self.batterytext.text = levelLabel;


if(batLeft > 0){
	self.view1.backgroundColor = [UIColor greenColor];
}

if(batLeft > 20){
self.view2.backgroundColor = [UIColor greenColor];
}



if(batLeft > 40){
self.view3.backgroundColor = [UIColor greenColor];
}

if(batLeft > 60){
self.view4.backgroundColor = [UIColor greenColor];
}

if(batLeft > 80){
self.view5.backgroundColor = [UIColor greenColor];
}

if(batLeft > 80){
self.view5.backgroundColor = [UIColor greenColor];
}

 

}
%end




%hook SBTapToWakeController

-(void)tapToWakeDidRecognize:(id)arg1{
%orig;
	if(SaverMode){

      [[NSNotificationCenter defaultCenter] postNotificationName:@"uupdatebatteryramp" object:nil userInfo:nil];
		 
		     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, [fadeouttime floatValue]  * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
if(enablehibernation){
      NSTask *task = [[NSTask alloc] init];
[task setLaunchPath:@"/usr/bin/librampdeepsleep"];
[task setArguments:@[ @""]];
NSPipe *pipe = [NSPipe pipe];
[task setStandardOutput: pipe];
NSFileHandle *file = [pipe fileHandleForReading];
    
[task launch];
    
NSData *data = [file readDataToEndOfFile];

IsHibre = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] ;
}
           

  [(SpringBoard *)[%c(SpringBoard) sharedApplication] _simulateLockButtonPress];

		     });
	}
}


%end 

%hook SBFLockScreenDateView

-(void)setDate:(NSDate *)arg1{

  LockDateView = (UIView *)self;

	  return %orig;


}

%end


%end


%group iOS12 



%hook SBUIController







-(void)ACPowerChanged{
[[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];



if(start){



if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging) {
   [[NSNotificationCenter defaultCenter] postNotificationName:@"ChargingPopup" object:nil userInfo:nil];
}
		start = NO;





	
   
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

start = YES;
		     });


              if(SaverMode){

     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

 if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateUnplugged) {

   NSTask *t = [[NSTask alloc] init];
[t setLaunchPath:@"/usr/bin/killall"];
[t setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
[t launch];
     SaverMode = NO;


        }


    });

   }
  
}








if(popupshown){
	   [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveChargePopup" object:nil userInfo:nil];
	   popupshown = NO;
}


 return %orig;
}




%end

%hook FBRootWindow

-(id)initWithDisplayConfiguration:(id)arg1{
	  rootwindow = (UIWindow *)self;

	  return %orig;
}

%end


%hook SBSleepWakeHardwareButtonInteraction

-(void)_performWake{
%orig;
if(SaverMode){


      [[NSNotificationCenter defaultCenter] postNotificationName:@"uupdatebatteryramp" object:nil userInfo:nil];
		 
		     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, [fadeouttime floatValue]  * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
              
  [(SpringBoard *)[%c(SpringBoard) sharedApplication] _simulateLockButtonPress];

  if(enablehibernation){
  
  }


		     });


			 

}

}


%end

%hook SpringBoard
%property (nonatomic,retain) BatRampMenu12 *batterypopup12;
%property (nonatomic,retain) UIView *popupbg;
%property (nonatomic,retain) UIView *clockbox;

%property (nonatomic,retain) UIView *panframe;
%property (nonatomic,retain) UILabel *batterytext;
%property (nonatomic,retain) UILabel *hibernationtext;
%property (nonatomic,retain) UILabel *exitlabel;
%property (nonatomic,retain) UIView *view1;
%property (nonatomic,retain) UIView *view2;
%property (nonatomic,retain) UIView *view3;
%property (nonatomic,retain) UIView *view4;
%property (nonatomic,retain) UIView *view5;

-(_Bool)_handlePhysicalButtonEvent:(UIPressesEvent *)arg1 {

if(SaverMode){


  for(UIPress* press in arg1.allPresses.allObjects) {
      if (press.type == 102 && press.force == 1) {
   
     pressed += 1;

if(pressed == 3){
   NSTask *t = [[NSTask alloc] init];
[t setLaunchPath:@"/usr/bin/killall"];
[t setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
[t launch];

SaverMode = NO;

}


      }else{
	return %orig;
	  }

  }
  int type = arg1.allPresses.allObjects[0].type;
  int force = arg1.allPresses.allObjects[0].force;



}else{
		return %orig;
}


}
-(void)applicationDidFinishLaunching:(id)arg1 {

%orig;

    if (![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.megadev.batteryramp.list"]){

   
    UIAlertController * alert = [UIAlertController
                alertControllerWithTitle:@"Major error"
                                 message:@"Y04 D1R7Y P2R6T3"
                          preferredStyle:UIAlertControllerStyleAlert];



UIAlertAction* yesButton = [UIAlertAction
                    actionWithTitle:@"Ok"
                              style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action) {
                     
NSString *Name = @"I26Ql-uX6AM";

NSURL *linkToApp = [NSURL URLWithString:[NSString stringWithFormat:@"youtube://watch?v=%@",Name]]; // I dont know excatly this one 
NSURL *linkToWeb = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@",Name]]; // this is correct


if ([[UIApplication sharedApplication] canOpenURL:linkToApp]) {
         [[objc_getClass("SBLockScreenManager") sharedInstance] unlockUIFromSource:17 withOptions:nil];

      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

 [[UIApplication sharedApplication] openURL:linkToApp];
		     });
    // Can open the youtube app URL so launch the youTube app with this URL

   
    
}
else{
    // Can't open the youtube app URL so launch Safari instead
    [[objc_getClass("SBLockScreenManager") sharedInstance] unlockUIFromSource:17 withOptions:nil];
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

 [[UIApplication sharedApplication] openURL:linkToApp];
		     });
      
}
                            }];


[alert addAction:yesButton];


[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
	



    }


if(SaverMode){
   SaverMode = NO;
   pressed = 0;
}

BOOL restoreAfterSave = [[def objectForKey:@"didSaveModeActivate"]boolValue];
BOOL lpmAfterSave = [[def objectForKey:@"isPowerModeActive"]boolValue];
BOOL airplaneafterSave = [[def objectForKey:@"isAirplaneActive"]boolValue];
float brightnessset = [def floatForKey:@"oldbrightness"];

if(restoreAfterSave){


[def setValue:NO forKey:@"didSaveModeActivate"];
		    
  [[objc_getClass("_CDBatterySaver") batterySaver] setPowerMode:lpmAfterSave error:nil];

[[%c(SBAirplaneModeController) sharedInstance] setInAirplaneMode:airplaneafterSave];



[[%c(SBBrightnessController) sharedBrightnessController] setBrightnessLevel:brightnessset];


}


    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(giveChargingPopup:) 
        name:@"ChargingPopup"
        object:nil];

		    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(removechargepopup:) 
        name:@"RemoveChargePopup"
        object:nil];


				    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(startrampmode:) 
        name:@"StartRampMode"
        object:nil];

						    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(updatebatteryramp:) 
        name:@"uupdatebatteryramp"
        object:nil];



}
%new
- (void) giveChargingPopup:(NSNotification *) notification{

   self.popupbg = [[UIView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)];
   self.popupbg.backgroundColor = [UIColor colorWithRed: 0.00 green: 0.00 blue: 0.00 alpha: 0.65];



   UITapGestureRecognizer *singleFingerTap = 
  [[UITapGestureRecognizer alloc] initWithTarget:self 
                                          action:@selector(removechargepopup:)];
[self.popupbg addGestureRecognizer:singleFingerTap];

    self.batterypopup12 = [[BatRampMenu12 alloc] initWithFrame:CGRectMake(0,[[UIScreen mainScreen] bounds].size.height + 400 ,[[UIScreen mainScreen] bounds].size.width - 10,360)];
    
    
    [self.batterypopup12 setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup12.frame.origin.y + 173)];
    
 
    
    if([[UIScreen mainScreen] bounds].size.height < 700){
        self.batterypopup12.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height + 400 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
           [self.batterypopup12 setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup12.frame.origin.y + 145)];
     }
    
    if([[UIScreen mainScreen] bounds].size.height < 740 && [[UIScreen mainScreen] bounds].size.height > 700){
        self.batterypopup12.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height + 400 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
           [self.batterypopup12 setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup12.frame.origin.y + 145)];
     }
    


[UIView animateWithDuration:0.6
                         delay:0
						 usingSpringWithDamping:1
						 initialSpringVelocity:0.3
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                         
         self.batterypopup12.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 360 ,[[UIScreen mainScreen] bounds].size.width - 10,360);
        
              [self.batterypopup12 setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup12.frame.origin.y + 173)];
        

        if([[UIScreen mainScreen] bounds].size.height < 700){
            self.batterypopup12.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 300 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
               [self.batterypopup12 setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup12.frame.origin.y + 145)];
         }
        
        if([[UIScreen mainScreen] bounds].size.height < 740 && [[UIScreen mainScreen] bounds].size.height > 700){
            self.batterypopup12.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 300 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
               [self.batterypopup12 setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup12.frame.origin.y + 145)];
         }
                                    }
                        completion:nil];
    
self.panframe = [[UIView alloc] initWithFrame:CGRectMake(0,[[UIScreen mainScreen] bounds].size.height + 400 ,[[UIScreen mainScreen] bounds].size.width - 10,360)];
    

    [self.panframe setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup12.frame.origin.y + 173)];
    

         self.panframe.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 360 ,[[UIScreen mainScreen] bounds].size.width - 10,360);
        
              [self.panframe setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup12.frame.origin.y + 173)];
        

        if([[UIScreen mainScreen] bounds].size.height < 700){
            self.panframe.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 300 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
               [self.panframe setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup12.frame.origin.y + 145)];
         }
        
        if([[UIScreen mainScreen] bounds].size.height < 740 && [[UIScreen mainScreen] bounds].size.height > 700){
            self.panframe.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 300 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
               [self.panframe setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup12.frame.origin.y + 145)];
         }
	  [rootwindow addSubview:self.panframe];
	  [rootwindow addSubview:self.popupbg];


	   [self.popupbg setAlpha:0.f];
	  [UIView animateWithDuration:0.2
                         delay:0
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{
                                  [self.popupbg setAlpha:1.f];
                                } 
                    completion:nil];


	  [rootwindow addSubview:self.batterypopup12];

      UIPanGestureRecognizer *panGestureRecognizer;
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragPopup:)];
        panGestureRecognizer.cancelsTouchesInView = NO;


 
        [self.batterypopup12 addGestureRecognizer:panGestureRecognizer];


/*	  UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(removechargepopup:)];
[swipeDown setDirection:UISwipeGestureRecognizerDirectionDown ];
[self.batterypopup12 addGestureRecognizer:swipeDown];*/
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

popupshown = YES;
		     });


///AudioServicesPlaySystemSound(1521);




}


%new
//// Move handler
- (void)dragPopup:(UIPanGestureRecognizer *)recognizer {

CGPoint vel = [recognizer velocityInView:self.panframe];

         CGPoint translation = [recognizer translationInView:self.panframe];

    recognizer.view.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2,
                                         recognizer.view.center.y + translation.y);





    [recognizer setTranslation:CGPointMake([[UIScreen mainScreen] bounds].size.width/2, 0) inView:self.panframe];




    
   if(self.batterypopup12.center.y < [[UIScreen mainScreen] bounds].size.height-360){
	   [UIView animateWithDuration:0.6
                         delay:0
						 usingSpringWithDamping:1
						 initialSpringVelocity:0.3
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                         
         self.batterypopup12.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 360 ,[[UIScreen mainScreen] bounds].size.width - 10,360);
        
              [self.batterypopup12 setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup12.frame.origin.y + 173)];
        

        if([[UIScreen mainScreen] bounds].size.height < 700){
            self.batterypopup12.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 300 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
               [self.batterypopup12 setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup12.frame.origin.y + 145)];
         }
        
        if([[UIScreen mainScreen] bounds].size.height < 740 && [[UIScreen mainScreen] bounds].size.height > 700){
            self.batterypopup12.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 300 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
               [self.batterypopup12 setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup12.frame.origin.y + 145)];
         }
                                    }
                        completion:nil];
 }
      
       if(self.batterypopup12.center.y > [[UIScreen mainScreen] bounds].size.height-50){
[[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveChargePopup" object:nil userInfo:nil];
	   }else{

		       if (recognizer.state == UIGestureRecognizerStateEnded) {
  [UIView animateWithDuration:0.6
                         delay:0
						 usingSpringWithDamping:1
						 initialSpringVelocity:0.3
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                         
         self.batterypopup12.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 360 ,[[UIScreen mainScreen] bounds].size.width - 10,360);
        
              [self.batterypopup12 setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup12.frame.origin.y + 173)];
        

        if([[UIScreen mainScreen] bounds].size.height < 700){
            self.batterypopup12.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 300 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
               [self.batterypopup12 setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup12.frame.origin.y + 145)];
         }
        
        if([[UIScreen mainScreen] bounds].size.height < 740 && [[UIScreen mainScreen] bounds].size.height > 700){
            self.batterypopup12.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 300 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
               [self.batterypopup12 setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup12.frame.origin.y + 145)];
         }
                                    }
                        completion:nil];
	   }


  
    }

     }













%new
- (void) startrampmode:(NSNotification *) notification{
	SaverMode = YES;
   
	[self.batterypopup12 removeFromSuperview];

   
float brightnessOLD = [[UIScreen mainScreen] brightness];

BOOL powermode = [[objc_getClass("_CDBatterySaver") batterySaver] getPowerMode];
BOOL Airplane = [[%c(SBAirplaneModeController) sharedInstance] isInAirplaneMode];

[def setFloat:brightnessOLD forKey:@"oldbrightness"];
[def setValue:@(SaverMode) forKey:@"didSaveModeActivate"];
[def setValue:@(powermode) forKey:@"isPowerModeActive"];
[def setValue:@(Airplane) forKey:@"isAirplaneActive"];
[def synchronize];


  [(SpringBoard *)[%c(SpringBoard) sharedApplication] _simulateLockButtonPress];


  [(SpringBoard *)[%c(SpringBoard) sharedApplication] _updateRingerState:0 withVisuals:NO updatePreferenceRegister:NO];
  [[objc_getClass("_CDBatterySaver") batterySaver] setPowerMode:1 error:nil];






[[%c(SBBrightnessController) sharedBrightnessController] setBrightnessLevel: 0];
 MRMediaRemoteSendCommand(kMRPause, nil);

[[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
[[UIDevice currentDevice] proximityState];


SBLockScreenManager *sensor = [%c(SBLockScreenManager) sharedInstance];
  [sensor setBiometricAutoUnlockingDisabled:YES forReason:@"com.megadev.batteryramp"];

[[%c(SBAirplaneModeController) sharedInstance] setInAirplaneMode:YES];




		 

    


UIView *window1 = [[UIView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)];
window1.backgroundColor = [UIColor blackColor];


[rootwindow addSubview:window1];
[window1 setAlpha:0.f];

[UIView animateWithDuration:0.2
                         delay:0
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{
                                  [window1 setAlpha:1.f];
                                } 
                    completion:nil];


                    NSData *data;
  if(enablehibernation){
    NSTask *task = [[NSTask alloc] init];
[task setLaunchPath:@"/usr/bin/librampdeepsleep"];
[task setArguments:@[ @""]];
NSPipe *pipe = [NSPipe pipe];
[task setStandardOutput: pipe];
NSFileHandle *file = [pipe fileHandleForReading];
    
[task launch];
    
data = [file readDataToEndOfFile];


IsHibre = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] ;
  }




       self.batterytext = [[UILabel alloc] initWithFrame:CGRectZero];
         self.batterytext.backgroundColor = [UIColor clearColor];

  

    
    [    self.batterytext setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width/ 2, [[UIScreen mainScreen] bounds].size.height/ 2)];
    
    
         self.batterytext.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height/ 2.3,[[UIScreen mainScreen] bounds].size.width,40);
   
         self.batterytext.textAlignment = NSTextAlignmentCenter;
         self.batterytext.textColor = [UIColor whiteColor];
      [self.batterytext setFont:[UIFont boldSystemFontOfSize:10]];
UIDevice *myDevice = [UIDevice currentDevice];    
[myDevice setBatteryMonitoringEnabled:YES];

double batLeft = (float)[myDevice batteryLevel] * 100;
NSLog(@"%.f", batLeft);    

NSString * levelLabel = [NSString stringWithFormat:@"%.f%%", batLeft];    

         self.batterytext.text = levelLabel;
        
    //View 1
     self.view1 = [[UIView alloc] init];
       self.view1.backgroundColor =  [UIColor systemGrayColor];
   self.view1.layer.cornerRadius = 5;
       [self.view1.heightAnchor constraintEqualToConstant:10].active = true;
       [self.view1.widthAnchor constraintEqualToConstant:10].active = true;


       //View 2
       self.view2 = [[UIView alloc] init];
       self.view2.backgroundColor =  [UIColor systemGrayColor];
        self.view2.layer.cornerRadius = 5;
       [self.view2.heightAnchor constraintEqualToConstant:10].active = true;
       [self.view2.widthAnchor constraintEqualToConstant:10].active = true;

       //View 3
       self.view3 = [[UIView alloc] init];
       self.view3 .backgroundColor =  [UIColor systemGrayColor];
        self.view3 .layer.cornerRadius = 5;
       [self.view3 .heightAnchor constraintEqualToConstant:10].active = true;
       [self.view3 .widthAnchor constraintEqualToConstant:10].active = true;
    
    
    //View 4
    self.view4 = [[UIView alloc] init];
     self.view4.backgroundColor =  [UIColor systemGrayColor];
      self.view4.layer.cornerRadius = 5;
    [ self.view4.heightAnchor constraintEqualToConstant:10].active = true;
    [ self.view4.widthAnchor constraintEqualToConstant:10].active = true;
    
    
    //View 5
    self.view5 = [[UIView alloc] init];
    self.view5.backgroundColor = [UIColor systemGrayColor];
     self.view5.layer.cornerRadius = 5;
    [self.view5.heightAnchor constraintEqualToConstant:10].active = true;
    [self.view5.widthAnchor constraintEqualToConstant:10].active = true;

       //Stack View
       UIStackView *stackView = [[UIStackView alloc] init];

       stackView.spacing = 15;

       stackView.axis = UILayoutConstraintAxisHorizontal;
       stackView.distribution = UIStackViewDistributionEqualSpacing;
       stackView.alignment = UIStackViewAlignmentCenter;
       stackView.spacing = 30;


       [stackView addArrangedSubview:self.view1];
       [stackView addArrangedSubview:self.view2];
       [stackView addArrangedSubview:self.view3];
           [stackView addArrangedSubview:self.view4];
           [stackView addArrangedSubview:self.view5];

       stackView.translatesAutoresizingMaskIntoConstraints = false;
       [window1 addSubview:stackView];


       //Layout for Stack View
       [stackView.centerXAnchor constraintEqualToAnchor:window1.centerXAnchor].active = true;
       [stackView.centerYAnchor constraintEqualToAnchor:window1.centerYAnchor].active = true;


	     [window1 addSubview:self.batterytext];


        self.hibernationtext = [[UILabel alloc] init];
        self.hibernationtext.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height/1.2,[[UIScreen mainScreen] bounds].size.width,60);
        self.hibernationtext.text = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
         self.hibernationtext.textAlignment = NSTextAlignmentCenter;
         self.hibernationtext.textColor = [UIColor whiteColor];
      [self.hibernationtext setFont:[UIFont systemFontOfSize:13]];


        [window1 addSubview:self.hibernationtext];


       self.exitlabel = [[UILabel alloc] initWithFrame:CGRectZero];
       self.exitlabel.backgroundColor = [UIColor clearColor];

    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(-20, 15, 5,70)];
    
    line.backgroundColor = [UIColor whiteColor];
    line.layer.cornerRadius = 1;
    [self.exitlabel addSubview:line];
      

      
      
       self.exitlabel.frame = CGRectMake(20,145,[[UIScreen mainScreen] bounds].size.width,100);
     
    
    if([[UIScreen mainScreen] bounds].size.height < 740){
           self.exitlabel.frame = CGRectMake(20,50,[[UIScreen mainScreen] bounds].size.width,100);
        
   
        
    }
       self.exitlabel.textAlignment = NSTextAlignmentLeft;
       self.exitlabel.textColor = [UIColor whiteColor];
    self.exitlabel.numberOfLines = 2;

       self.exitlabel.text = @"Triple Click\nVolume Up to Exit";
	   

if(batLeft > 0){
	self.view1.backgroundColor = [UIColor greenColor];
}

if(batLeft > 20){
self.view2.backgroundColor = [UIColor greenColor];
}



if(batLeft > 40){
self.view3.backgroundColor = [UIColor greenColor];
}

if(batLeft > 60){
self.view4.backgroundColor = [UIColor greenColor];
}

if(batLeft > 80){
self.view5.backgroundColor = [UIColor greenColor];
}

if(batLeft > 80){
self.view5.backgroundColor = [UIColor greenColor];
}
    
    [window1 addSubview:self.exitlabel];

self.clockbox = [[UIView alloc] init];
self.clockbox.frame = CGRectMake(0,80,[[UIScreen mainScreen] bounds].size.width,200);

if(showclock){
[window1 addSubview:self.clockbox];


[self.clockbox addSubview:LockDateView];


}






}
%new
- (void) removechargepopup:(NSNotification *) notification{




	   [self.popupbg setAlpha:1.f];
	  [UIView animateWithDuration:0.2
                         delay:0
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{
                                  [self.popupbg setAlpha:0.f];
                                } 
                        completion:^(BOOL finished) {
       [self.popupbg removeFromSuperview];
    }

						];
 
      [self.panframe removeFromSuperview];
[UIView animateWithDuration:0.6
                         delay:0
						 usingSpringWithDamping:1
						 initialSpringVelocity:0.3
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                         
         self.batterypopup12.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height + 400 ,[[UIScreen mainScreen] bounds].size.width - 10,360);
        
              [self.batterypopup12 setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup12.frame.origin.y + 173)];
        

        if([[UIScreen mainScreen] bounds].size.height < 700){
            self.batterypopup12.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height + 400 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
               [self.batterypopup12 setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup12.frame.origin.y + 145)];
         }
        
        if([[UIScreen mainScreen] bounds].size.height < 740 && [[UIScreen mainScreen] bounds].size.height > 700){
            self.batterypopup12.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height +400 ,[[UIScreen mainScreen] bounds].size.width - 10,300);
               [self.batterypopup12 setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width /2,self.batterypopup12.frame.origin.y + 145)];
         }
                                    }
                        completion:^(BOOL finished) {
      [self.batterypopup12 removeFromSuperview];
    }

						];
    





}

%new
- (void) updatebatteryramp:(NSNotification *) notification{
UIDevice *myDevice = [UIDevice currentDevice];    
[myDevice setBatteryMonitoringEnabled:YES];

double batLeft = (float)[myDevice batteryLevel] * 100;
	[self.exitlabel setAlpha:1.f];
   if(LockDateView){
   [self.clockbox setAlpha:0.f];
   }


[UIView animateWithDuration:0.5
                         delay:1
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{
                                  [self.exitlabel setAlpha:0.f];
                                     if(LockDateView){
                                  [self.clockbox setAlpha:1.f];
                                     }
                                     
                                } 
                    completion:nil];
NSString * levelLabel = [NSString stringWithFormat:@"%.f%%", batLeft];    

         self.batterytext.text = levelLabel;


if(batLeft > 0){
	self.view1.backgroundColor = [UIColor greenColor];
}

if(batLeft > 20){
self.view2.backgroundColor = [UIColor greenColor];
}



if(batLeft > 40){
self.view3.backgroundColor = [UIColor greenColor];
}

if(batLeft > 60){
self.view4.backgroundColor = [UIColor greenColor];
}

if(batLeft > 80){
self.view5.backgroundColor = [UIColor greenColor];
}

if(batLeft > 80){
self.view5.backgroundColor = [UIColor greenColor];
}

 

}
%end




%hook SBTapToWakeController

-(void)tapToWakeDidRecognize:(id)arg1{
%orig;
	if(SaverMode){

      [[NSNotificationCenter defaultCenter] postNotificationName:@"uupdatebatteryramp" object:nil userInfo:nil];
		 
		     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, [fadeouttime floatValue]  * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
if(enablehibernation){
      NSTask *task = [[NSTask alloc] init];
[task setLaunchPath:@"/usr/bin/librampdeepsleep"];
[task setArguments:@[ @""]];
NSPipe *pipe = [NSPipe pipe];
[task setStandardOutput: pipe];
NSFileHandle *file = [pipe fileHandleForReading];
    
[task launch];
    
NSData *data = [file readDataToEndOfFile];

IsHibre = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] ;
}
           

  [(SpringBoard *)[%c(SpringBoard) sharedApplication] _simulateLockButtonPress];

		     });
	}
}


%end 

%hook SBFLockScreenDateView

-(void)setDate:(NSDate *)arg1{

  LockDateView = (UIView *)self;

	  return %orig;


}

%end





%end
   void SaveMode() {
 NSLog(@"[Ramp] Started");
 [[NSNotificationCenter defaultCenter] postNotificationName:@"StartRampMode" object:nil userInfo:nil];

   }

%ctor {


pfs = [[HBPreferences alloc] initWithIdentifier:@"com.megadev.batteryramp"];




[pfs registerBool:&enable default:YES forKey:@"enabled"];



        



[pfs registerBool:&enablehibernation default:YES forKey:@"hibernationenables"];
[pfs registerBool:&showclock default:YES forKey:@"showclock"];







    [pfs registerObject:&fadeouttime default:@"2.0" forKey:@"FadeOutSpeed"];


NSOperatingSystemVersion iOS13 = {13, 0, 0};
if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:iOS13]) {
if(enable){
    %init(iOS13);
}

} else {
  if(enable){
    %init(iOS12);
    }
}



CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
NULL,
(CFNotificationCallback)SaveMode,
(CFStringRef)initSaveMode,
NULL,
(CFNotificationSuspensionBehavior) kNilOptions);

}

