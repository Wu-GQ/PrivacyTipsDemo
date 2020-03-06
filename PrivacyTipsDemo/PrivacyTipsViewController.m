//
//  PrivacyTipsViewController.m
//  KiiikMobilePlat
//
//  Created by wuguoqiao on 2020/2/28.
//  Copyright © 2020 kiiik. All rights reserved.
//

#import "PrivacyTipsViewController.h"


@interface PrivacyTipsViewController () <UITextViewDelegate>

/// 提示信息对话框
@property (weak, nonatomic) IBOutlet UIView *tipsView;
/// 提示信息文本视图
@property (weak, nonatomic) IBOutlet UITextView *tipsTextView;
/// 提示信息文本视图高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsTextViewHeightConstraint;

@end


@implementation PrivacyTipsViewController

static NSString *const AgreePrivacyTipsString = @"IsAgreedPrivacyTips";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tipsView.layer.cornerRadius = 5;
    
    _tipsTextView.delegate = self;
    
    // 判断是否已同意隐私条款
    if ([[NSUserDefaults standardUserDefaults] boolForKey:AgreePrivacyTipsString]) {
        _tipsView.hidden = YES;
        
        if (_privacyTipsAlertEventBlock) {
            _privacyTipsAlertEventBlock(YES);
        }
    } else {
        NSString *tipsString = @"　为了更好保护您的个人信息，请在使用XXXX的产品和/或服务前，仔细阅读并充分了解\"风险提示和隐私政策\"。\n　在使用过程中，我们可能会收集包括但不限于：XXXXX等个人信息。\n　您可阅读《风险提示和隐私政策》了解详细信息。如您同意，请点“同意”开始接受我们的服务。";
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tipsString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];
        // 设置行间距和段落间距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [paragraphStyle setParagraphSpacing:7];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tipsString length])];
        // 设置超链接文本样式
        // MARK: 若NSLinkAttributeName字段包含中文时，需要对其进行特殊处理，否则无法触发UITextViewDelegate
        [attributedString addAttributes:@{NSForegroundColorAttributeName: [UIColor blueColor], NSLinkAttributeName: @"https://www.baidu.com/"} range:[tipsString rangeOfString:@"《风险提示和隐私政策》"]];
        
        _tipsTextView.attributedText = attributedString;
        
        // 文本段落间距，该属性默认为5，如果想保留默认值，则在计算文本高度时，需要将限制宽度再减去10
        _tipsTextView.textContainer.lineFragmentPadding = 0;
        
        // 计算富文本的高度
        // 32: 左右间距各为16
        CGRect tipsStringRect = [attributedString boundingRectWithSize:CGSizeMake(self.view.bounds.size.width * 0.7 - 32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        
        // MARK: UITextView高度自适应，https://www.jianshu.com/p/32a4747a19fb
        // 16: tipsTextView.textContainerInset({8, 0, 8, 0})，系统设定文本容器和UITextView的上下间距各为8
        _tipsTextViewHeightConstraint.constant = tipsStringRect.size.height + 16;
    }
}


#pragma mark - UITextViewDelegate

/// 当textView指定范围的内容与URL交互时
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    // 跳转到点击的链接，若链接为自定义格式或者使用自己的方式打开链接，可在此方法内进行处理
    
    // 当YES时，等同于[[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    // 若链接为自定义格式，需要在此方法内进行处理，并且return NO
    return YES;
}


#pragma mark - UIControl Event

/// 不同意按钮点击事件
- (IBAction)cancelButtonEvent:(id)sender {
    if (_privacyTipsAlertEventBlock) {
        _privacyTipsAlertEventBlock(NO);
    }
}

/// 同意按钮点击事件
- (IBAction)confirmButtonEvent:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:AgreePrivacyTipsString];
    [userDefaults synchronize];
    
    _tipsView.hidden = YES;
    
    if (_privacyTipsAlertEventBlock) {
        _privacyTipsAlertEventBlock(YES);
    }
}

@end
