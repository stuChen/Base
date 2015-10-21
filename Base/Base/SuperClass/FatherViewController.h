//
//  FatherViewController.h
//  Sahara
//
//  Created by huangcan on 15/5/20.
//  Copyright (c) 2015年 bodecn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FatherViewController : UIViewController

-(void)addCustomNavBarTitle:(NSString *)title
                    leftBar:(UIButton *)leftButton
                   rigthBar:(UIButton *)rigthButton whetherAddBackBar:(BOOL)backBar;


@end
