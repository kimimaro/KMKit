//
//  KMAlertView.h
//  Article
//
//  Created by Yu Tianhang on 12-12-25.
//
//

#import "KMViewBase.h"


@protocol KMAlertViewDelegate;

@interface KMAlertView : KMViewBase

@property (nonatomic, weak) id<KMAlertViewDelegate> delegate;    // weak reference

@property (nonatomic) NSString *title;
@property (nonatomic) NSArray *messages;

@property (nonatomic) NSInteger maxCharacterCount;   // 140
@property (nonatomic) NSInteger cancelButtonIndex;   // 0
@property (nonatomic) NSInteger okButtonIndex;       // 1

@property (nonatomic, readonly) UITextView *textView;
@property (nonatomic, readonly, getter=isVisible) BOOL visible;
@property (nonatomic) id userInfo;

// default CGPointZero，这样外界就不能设置在 (0,0) 点显示dialog，一般情况下没有这样的需求
@property (nonatomic, readonly) CGPoint defaultOffsetOrigin;    // depend current orientation
@property (nonatomic, readonly) CGFloat defaultDialogWidth;
@property (nonatomic, readonly) CGFloat defaultDialogHeight;

@property (nonatomic, assign) CGPoint offsetOrigin;
@property (nonatomic, assign) CGPoint portraitOffsetOrigin;
@property (nonatomic, assign) CGPoint landscapeOffsetOrigin;

- (id)initWithTitle:(NSString *)title messages:(NSArray *)messages delegate:(id<KMAlertViewDelegate>)delegate;
- (void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@end


@protocol KMAlertViewDelegate <NSObject>
@optional
- (void)kmAlertView:(KMAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)willPresentKMAlertView:(KMAlertView *)alertView;  // before animation and showing view
- (void)didPresentKMAlertView:(KMAlertView *)alertView;  // after animation

- (void)kmAlertView:(KMAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)kmAlertView:(KMAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
@end
