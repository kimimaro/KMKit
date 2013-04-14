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

@property (nonatomic,assign) id<KMAlertViewDelegate> delegate;    // weak reference

@property (nonatomic) NSString *title;
@property (nonatomic) NSArray *messages;

@property (nonatomic) NSInteger maxCharacterCount;   // 140
@property (nonatomic) NSInteger cancelButtonIndex;   // 0
@property (nonatomic) NSInteger okButtonIndex;       // 1

@property (nonatomic, readonly) UITextView *textView;
@property (nonatomic, readonly, getter=isVisible) BOOL visible;
@property (nonatomic) id userInfo;

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
