//
//  PrivacyTipsViewController.h
//  KiiikMobilePlat
//
//  Created by wuguoqiao on 2020/2/28.
//  Copyright © 2020 kiiik. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

/// 提示框同意与否的回调
typedef void(^PrivacyTipsAlertEventBlock)(BOOL isAgreed);

/// 进入APP时的隐私条款提示页
@interface PrivacyTipsViewController : UIViewController

@property(nonatomic, copy) PrivacyTipsAlertEventBlock privacyTipsAlertEventBlock;

@end

NS_ASSUME_NONNULL_END
