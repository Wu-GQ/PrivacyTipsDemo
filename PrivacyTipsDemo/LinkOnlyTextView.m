//
//  LinkOnlyTextView.m
//  KiiikMobilePlat
//
//  Created by wuguoqiao on 2020/3/2.
//  Copyright © 2020 kiiik. All rights reserved.
//

#import "LinkOnlyTextView.h"


@implementation LinkOnlyTextView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // 获得点击位置
    UITextPosition *textPosition = [self closestPositionToPoint:point];
    NSInteger location = [self offsetFromPosition:self.beginningOfDocument toPosition:textPosition];
    
    // 除被设置超链接的"《风险提示和隐私政策》"区域外，不响应事件
    NSRange range = [self.attributedText.string rangeOfString:@"《风险提示和隐私政策》"];
    return location >= range.location && location < range.location + range.length;
}

@end
