//
//  BatRampMenu.m
//  Popup menu
//
//  Created by Domien Fovel on 16/05/2020.
//  Copyright © 2020 megadev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BatRampMenu.h"

@interface BatRampMenu ()

@end

@implementation BatRampMenu

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _configureView];
    }
    return self;
}

-(void)_configureView {
  

           if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){
      self.backgroundColor = [UIColor systemGray6Color];
    }else{
          self.backgroundColor = [UIColor whiteColor];
	
    }
    self.layer.cornerRadius = 35;
    
    
    
      UILabel *Title = [[UILabel alloc] initWithFrame:CGRectZero];
     Title.backgroundColor = [UIColor clearColor];

  

    
    [Title setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
    
    
     Title.frame = CGRectMake(0,20,self.frame.size.width,40);
   
     Title.textAlignment = NSTextAlignmentCenter;
     Title.textColor = [UIColor labelColor];
    if([[UIScreen mainScreen] bounds].size.height > 667){
             [Title setFont:[UIFont systemFontOfSize:35 weight:UIFontWeightSemibold]];
    }else{
              [Title setFont:[UIFont systemFontOfSize:25 weight:UIFontWeightSemibold]];
    }

     Title.text = @"BatteryRamp";

     
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"bolt.circle.fill"]];
    if([[UIScreen mainScreen] bounds].size.height > 740){
         imageView.frame = CGRectMake(0, 0, 80, 80);
        imageView.center = imageView.superview.center;
        [imageView setCenter:CGPointMake(self.frame.size.width / 2, 120)];
    }else{
               imageView.frame = CGRectMake(0, 0, 50, 50);
        imageView.center = imageView.superview.center;
        [imageView setCenter:CGPointMake(self.frame.size.width / 2, 90)];
    }



       

         UILabel *menutext = [[UILabel alloc] initWithFrame:CGRectZero];


         menutext.textColor = [UIColor labelColor];
    if([[UIScreen mainScreen] bounds].size.height > 740){
          [menutext setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
         menutext.frame = CGRectMake(40,170,self.frame.size.width - 80,100);
    }else{
          [menutext setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 - 400)];
         menutext.frame = CGRectMake(40,115,self.frame.size.width - 80,100);
    }
      

        

         menutext.textAlignment = NSTextAlignmentCenter;
    
        if([[UIScreen mainScreen] bounds].size.height > 740){
           [menutext setFont:[UIFont systemFontOfSize:13]];
    }else{
            [menutext setFont:[UIFont systemFontOfSize:12]];
    }

    menutext.numberOfLines = 0;
    
         menutext.text = @"Would you like to enter BatteryRamp mode? This mode will place your device in a state of limited functionality to ensure the fastest possible charging, by reducing your device's discharge rate. Upon unplugging, your device will respring and return to its normal state.";
         
  
    
     UIButton *nextButton = [[UIButton alloc] init];
    
    
    if([[UIScreen mainScreen] bounds].size.height > 740){

        if([[UIScreen mainScreen] bounds].size.height > 810){
            
                nextButton.frame = CGRectMake(40,310, [[UIScreen mainScreen] bounds].size.width/1.271875, [[UIScreen mainScreen] bounds].size.height/15.34);
            
             [nextButton setCenter:CGPointMake(self.frame.size.width / 2, 310)];
            
        }else{
                nextButton.frame = CGRectMake(40,250, [[UIScreen mainScreen] bounds].size.width/1.271875, [[UIScreen mainScreen] bounds].size.height/15.34);
                  [nextButton setCenter:CGPointMake(self.frame.size.width / 2, 250)];
        }
    
    }else{
                 nextButton.frame = CGRectMake(40,235, [[UIScreen mainScreen] bounds].size.width/1.271875, [[UIScreen mainScreen] bounds].size.height/15.34);
               [nextButton setCenter:CGPointMake(self.frame.size.width / 2, 235)];
    }
      
    

     [nextButton setTitle: @"Enable" forState:UIControlStateNormal];

     [nextButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    nextButton.backgroundColor = [UIColor systemGray4Color];
    nextButton.layer.cornerRadius = 13;
     nextButton.titleLabel.textAlignment = NSTextAlignmentCenter;
     nextButton.titleLabel.textColor = [UIColor blackColor];
    nextButton.titleLabel.font =  [UIFont boldSystemFontOfSize:18];
   


     [nextButton addTarget:self action:@selector(StartButton) forControlEvents:UIControlEventTouchUpInside];

   
     UIButton *cancelButton = [[UIButton alloc] init];
    
    

  
    [cancelButton setImage:[UIImage systemImageNamed:@"multiply"] forState:UIControlStateNormal];

              if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){
        cancelButton.tintColor = [UIColor colorWithRed: 0.73 green: 0.74 blue: 0.75 alpha: 1.00];
    }else{
            
              cancelButton.tintColor = [UIColor colorWithRed: 0.40 green: 0.40 blue: 0.40 alpha: 0.30];
	
    }


    cancelButton.backgroundColor = [UIColor systemGray3Color];
                 
cancelButton.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 60,25,30,30);
      cancelButton.layer.cornerRadius = 15;

     [cancelButton addTarget:self action:@selector(cancelButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:cancelButton];
     [self addSubview:nextButton];
    [self addSubview:menutext];
    [self addSubview:Title];
    [self addSubview:imageView];
       
    
    
    
    

}


-(void)StartButton{
CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)initSaveMode, nil, nil, true);



}


-(void)cancelButton{
   [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveChargePopup" object:nil userInfo:nil];
}

@end
