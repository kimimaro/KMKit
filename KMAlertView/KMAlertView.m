//
//  KMAlertView.m
//  Article
//
//  Created by Yu Tianhang on 12-12-25.
//
//

#import <QuartzCore/QuartzCore.h>
#import "KMAlertView.h"
#import "ToolbarButton.h"
#import "UIColor+UIColorAddtions.h"
#import "UILabel+UILabelAdditions.h"

#define DegreesToRadians(degrees) (degrees * M_PI / 180)
#define MaxCharacterCount 140

#define DialogWidth 230
#define DialogHeight 160
#define DefaultTopPadding ([KMCommon is568Screen] ? 84.f : 30.f)
//#define DefaultTopPadding ([KMCommon is568Screen] ? 110.f : 66.f)

#define MaxCharacterCount 140

#define KMAlertViewHelperWordButtonTagPrefix 10000

@interface KMAlertView () <UITextViewDelegate>

@property (nonatomic) UIWindow *keyWindow;
@property (nonatomic) UIWindow *storeMainWindow;

@property (nonatomic) UIView *backgroundView;

@property (nonatomic, readwrite) KMTextView *textView;
@property (nonatomic) UIView *dialogView;
@property (nonatomic) UIImageView *dialogBackgroundView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *textViewBackground;
@property (nonatomic) UILabel *placeHolder;

@property (nonatomic) UIToolbar *helperToolbar;

@property (nonatomic) NSMutableArray *messageLabels;
@property (nonatomic) NSMutableArray *buttons;

@property (nonatomic) CGFloat dialogPortraitOriginY;
@property (nonatomic) CGFloat dialogLanscapeOriginY;

@property(nonatomic, readwrite, getter=isVisible) BOOL visible;
@end

@implementation KMAlertView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithTitle:(NSString *)title messages:(NSArray *)messages delegate:(id<KMAlertViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        
        _dialogLanscapeOriginY = 0;
        _dialogPortraitOriginY = 0;
        
        self.title = title;
        self.messages = messages;
        self.delegate = delegate;
        
        self.messageLabels = [NSMutableArray arrayWithCapacity:[_messages count]];
        self.buttons = [NSMutableArray arrayWithCapacity:2];
        
        self.maxCharacterCount = MaxCharacterCount;
        self.cancelButtonIndex = 0;
        self.okButtonIndex = 1;
        
        [self loadView];
        
        [self registerNotifications];
    }
    return self;
}

- (void)loadView
{
    UIImage *dialogBackgroundImage = [UIImage imageNamed:@"popupbg_dialog.png"];
    dialogBackgroundImage = [dialogBackgroundImage stretchableImageWithLeftCapWidth:dialogBackgroundImage.size.width/2 topCapHeight:dialogBackgroundImage.size.height/2];
    
    CGRect vFrame = CGRectMake(0, 0, screenSize().width, screenSize().height);
    
    self.keyWindow = [[UIWindow alloc] initWithFrame:vFrame];
    self.frame = vFrame;
    
    self.backgroundView = [[UIView alloc] initWithFrame:vFrame];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0.3;
    [self addSubview:_backgroundView];
    
    CGFloat topPadding = DefaultTopPadding;
    CGFloat dialogWidth = DialogWidth;
    CGFloat dialogHeight = DialogHeight;
    CGRect dialogFrame = CGRectMake((vFrame.size.width - dialogWidth)/2,
                                    topPadding,
                                    dialogWidth,
                                    dialogHeight);
    
    self.dialogView = [[UIView alloc] initWithFrame:dialogFrame];
    [self addSubview:_dialogView];
    
    // dialog subviews
    self.dialogBackgroundView = [[UIImageView alloc] initWithImage:dialogBackgroundImage];
    [_dialogView addSubview:_dialogBackgroundView];
    
    CGRect tFrame = dialogFrame;
    tFrame.origin.x = 0;
    tFrame.origin.y = 0;
    _dialogBackgroundView.frame = tFrame;
    
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = _title;
    _titleLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    _titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_titleLabel sizeToFit];
    [_dialogView addSubview:_titleLabel];
    
    tFrame = _titleLabel.frame;
    tFrame.origin.x = (dialogWidth - tFrame.size.width)/2;
    tFrame.origin.y = 12.f;
    _titleLabel.frame = tFrame;
    
    CGFloat horizontalPadding = 10.f;
    
    __block CGRect messageFrame = tFrame;
    [_messages enumerateObjectsUsingBlock:^(NSString *message, NSUInteger idx, BOOL *stop) {
        if (message && [message length] > 0) {
            
            UILabel *messageLabel = [[UILabel alloc] init];
            messageLabel.backgroundColor = [UIColor clearColor];
            messageLabel.text = message;
            messageLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
            messageLabel.font = [UIFont systemFontOfSize:11.f];
            [_dialogView addSubview:messageLabel];
            [_messageLabels addObject:messageLabel];
            
            [messageLabel sizeToFit];
            
            messageFrame.origin.y += messageFrame.size.height + 6.f;
            messageFrame.size.width = MIN(messageLabel.frame.size.width, dialogFrame.size.width - 2*horizontalPadding);
            messageFrame.size.height = messageLabel.frame.size.height;
            messageFrame.origin.x = (dialogFrame.size.width - messageFrame.size.width)/2;
            
            messageLabel.frame = messageFrame;
        }
    }];
    
    tFrame.origin.x = horizontalPadding;
    tFrame.origin.y = CGRectGetMaxY(messageFrame) + ([_messageLabels count] > 0 ? 6.f : 12.f);
    tFrame.size.width = dialogWidth - 2*horizontalPadding;
    tFrame.size.height = dialogHeight - tFrame.origin.y - 44.f;
    
    UIImage *textFieldBackgroundImage = [UIImage imageNamed:@"inputbox_dialog.png"];
    textFieldBackgroundImage = [textFieldBackgroundImage stretchableImageWithLeftCapWidth:textFieldBackgroundImage.size.width/2 topCapHeight:textFieldBackgroundImage.size.height/2];
    
    self.textViewBackground = [[UIImageView alloc] initWithImage:textFieldBackgroundImage];
    _textViewBackground.frame = tFrame;
    [_dialogView addSubview:_textViewBackground];
    
    tFrame.origin.x += 2.f;
    tFrame.origin.y += 2.f;
    tFrame.size.width -= 4.f;
    tFrame.size.height -= 4.f;
    
    self.textView = [[KMTextView alloc] initWithFrame:tFrame];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:14.f];
    _textView.textColor = [UIColor colorWithHexString:@"646464"];
    _textView.delegate = self;
    [_dialogView addSubview:_textView];
    
    self.placeHolder = [[UILabel alloc] init];
    _placeHolder.backgroundColor = [UIColor clearColor];
    _placeHolder.text = [NSString stringWithFormat:@"%d", _maxCharacterCount];
    _placeHolder.textColor = [UIColor colorWithHexString:@"919191"];
    _placeHolder.font = [UIFont systemFontOfSize:11.f];
    [_dialogView addSubview:_placeHolder];
    
    [_placeHolder sizeToFit];
    
    CGRect placeHolderFrame = _placeHolder.frame;
    placeHolderFrame.origin.x = CGRectGetMaxX(_textView.frame) - placeHolderFrame.size.width - 5.f;
    placeHolderFrame.origin.y = CGRectGetMaxY(_textView.frame) - placeHolderFrame.size.height - 5.f;
    _placeHolder.frame = placeHolderFrame;
    
    CGFloat buttonHorizontalPadding = 15.f;
    
    CGRect buttonFrame = tFrame;
    buttonFrame.origin.x = buttonHorizontalPadding;
    buttonFrame.origin.y = CGRectGetMaxY(_textViewBackground.frame) + 7.f;
    buttonFrame.size.width = 80.f;
    buttonFrame.size.height = 30.f;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:NSLocalizedString(@"_KMAlertViewCancel", ) forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelbtn_dialog.png"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelbtn_dialog_press.png"] forState:UIControlStateHighlighted];
    [cancelButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithHexString:@"1e1e1e"] forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [cancelButton setTitleShadowColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [cancelButton setTitleShadowColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
    cancelButton.titleLabel.shadowOffset = CGSizeMake(0, 1.f);
    [cancelButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_dialogView addSubview:cancelButton];
    [_buttons addObject:cancelButton];
    
    cancelButton.frame = buttonFrame;
    
    buttonFrame.origin.x = CGRectGetMaxX(cancelButton.frame) + 40.f;
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setTitle:NSLocalizedString(@"_KMAlertViewConfirm", ) forState:UIControlStateNormal];
    [okButton setBackgroundImage:[UIImage imageNamed:@"okbtn_dialog.png"] forState:UIControlStateNormal];
    [okButton setBackgroundImage:[UIImage imageNamed:@"okbtn_dialog_press.png"] forState:UIControlStateHighlighted];
    [okButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor colorWithHexString:@"1e1e1e"] forState:UIControlStateHighlighted];
    okButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [okButton setTitleShadowColor:[UIColor colorWithHexString:@"c4f146"] forState:UIControlStateNormal];
    [okButton setTitleShadowColor:[UIColor colorWithHexString:@"c4f146"] forState:UIControlStateHighlighted];
    okButton.titleLabel.shadowOffset = CGSizeMake(0, 1.f);
    [okButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_dialogView addSubview:okButton];
    [_buttons addObject:okButton];
    
    okButton.frame = buttonFrame;
}

#pragma mark - notifications

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUITextViewTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:_textView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarFrame:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (void)reportKeyboardWillChangeFrame:(NSNotification *)notification
{
    CGFloat duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    keyboardFrame = [mainWindow.rootViewController.view convertRect:keyboardFrame fromView:mainWindow];
    
    CGRect barFrame = _helperToolbar.frame;
    barFrame.origin.y = CGRectGetMinY(keyboardFrame) - SSHeight(_helperToolbar);
    barFrame.size.width = keyboardFrame.size.width;
    
    [UIView animateWithDuration:duration animations:^{
        _helperToolbar.frame = barFrame;
    }];
}

#pragma mark - public

- (void)show
{
    [self loadHelperToolbarIfNecessary];
    
    if (![_keyWindow isKeyWindow]) {
        
        self.storeMainWindow = [[UIApplication sharedApplication] keyWindow];
        
        [_keyWindow addSubview:self];   // self retained
        [_keyWindow makeKeyAndVisible];
        
        [_textView becomeFirstResponder];
        
        if (_delegate && [_delegate respondsToSelector:@selector(willPresentKMAlertView:)]) {
            [_delegate willPresentKMAlertView:self];
        }
        
        CGAffineTransform zoomIn = CGAffineTransformScale(self.transform, 1.3, 1.3);
        CGAffineTransform zoomOut = CGAffineTransformScale(self.transform, 1, 1);
        
        [UIView animateWithDuration:0.3 animations:^{
            _dialogView.transform = zoomIn;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                _dialogView.transform = zoomOut;
            } completion:^(BOOL finished) {
                if (_delegate && [_delegate respondsToSelector:@selector(didPresentKMAlertView:)]) {
                    [_delegate didPresentKMAlertView:self];
                }
                self.visible = YES;
                [self updateFrames];
            }];
        }];
    }
    else {
        [self updateFrames];
    }
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    self.visible = NO;
    [_textView resignFirstResponder];
    
    if (buttonIndex < [_buttons count]) {
        if (_delegate && [_delegate respondsToSelector:@selector(kmAlertView:willDismissWithButtonIndex:)]) {
            [_delegate kmAlertView:self willDismissWithButtonIndex:buttonIndex];
        }
    }
    
    if (animated) {
        
        CGAffineTransform zoomIn = CGAffineTransformScale(self.transform, 1.1, 1.1);
        CGAffineTransform zoomOut = CGAffineTransformScale(self.transform, 0.7, 0.7);
        
        [UIView animateWithDuration:0.2 animations:^{
            _dialogView.transform = zoomIn;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                _dialogView.transform = zoomOut;
            } completion:^(BOOL finished) {
                if (_delegate && [_delegate respondsToSelector:@selector(kmAlertView:didDismissWithButtonIndex:)]) {
                    [_delegate kmAlertView:self didDismissWithButtonIndex:buttonIndex];
                }
                
                [self clear];
            }];
        }];
    }
    else {
        if (_delegate && [_delegate respondsToSelector:@selector(kmAlertView:didDismissWithButtonIndex:)]) {
            [_delegate kmAlertView:self didDismissWithButtonIndex:buttonIndex];
        }
        
        [self clear];
    }
}

- (void)didChangeStatusBarFrame:(NSNotification *)notification
{
    [self updateFrames];
}

#pragma mark - setter&getter

- (void)setMaxCharacterCount:(NSInteger)maxCharacterCount
{
    _maxCharacterCount = maxCharacterCount;
    [self refreshPlaceHolder];
}

- (CGPoint)defaultOffsetOrigin
{
    CGFloat originX = ([KMAlertView applicationSize].width - DialogWidth) / 2.f;
    CGFloat originY = DefaultTopPadding;
    return CGPointMake(originX, originY);
}

- (CGFloat)defaultDialogWidth
{
    return DialogWidth;
}

- (CGFloat)defaultDialogHeight
{
    return DialogHeight;
}

#pragma mark - private

- (void)updateFrames
{
    self.transform = [self transformForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    self.frame = [self frameForSelf];
    [self updateSubviewFrames];
}

- (void)updateSubviewFrames
{
    _backgroundView.frame = self.bounds;
    _dialogView.frame = [self frameForDialogView];
    
    //    _dialogView.backgroundColor = [UIColor purpleColor];
}

- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation {
    
    switch (orientation) {
            
        case UIInterfaceOrientationLandscapeLeft:
            return CGAffineTransformMakeRotation(-DegreesToRadians(90));
            
        case UIInterfaceOrientationLandscapeRight:
            return CGAffineTransformMakeRotation(DegreesToRadians(90));
            
        case UIInterfaceOrientationPortraitUpsideDown:
            return CGAffineTransformMakeRotation(DegreesToRadians(180));
            
        case UIInterfaceOrientationPortrait:
        default:
            return CGAffineTransformMakeRotation(DegreesToRadians(0));
    }
}

- (void)clear
{
    [_keyWindow resignKeyWindow];
    [_storeMainWindow makeKeyAndVisible];
    
    [self removeFromSuperview];
}

- (void)refreshPlaceHolder
{
    _placeHolder.text = [NSString stringWithFormat:@"%d", _maxCharacterCount - [_textView.text length]];
    [_placeHolder sizeToFit];
    
    CGRect placeHolderFrame = _placeHolder.frame;
    placeHolderFrame.origin.x = CGRectGetMaxX(_textView.frame) - placeHolderFrame.size.width - 5.f;
    placeHolderFrame.origin.y = CGRectGetMaxY(_textView.frame) - placeHolderFrame.size.height - 5.f;
    _placeHolder.frame = placeHolderFrame;
}

- (void)loadHelperToolbarIfNecessary
{
    if (!_helperToolbar) {
        self.helperToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SSHeight(self), SSWidth(self), 40)];
        _helperToolbar.hidden = YES;
        [self addSubview:_helperToolbar];
    }
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(helperWordsInkmAlertView:)]) {
        NSArray *words = [_dataSource helperWordsInkmAlertView:self];
        
        CGRect tFrame = _helperToolbar.frame;
        if ([words count] > 0) {
            tFrame.size.height = 44.f;
            _helperToolbar.hidden = NO;
            
            NSMutableArray *mutItems = [NSMutableArray arrayWithCapacity:5];
            [words enumerateObjectsUsingBlock:^(NSString *word, NSUInteger idx, BOOL *stop) {
                ToolbarButton *tButton = [ToolbarButton buttonWithType:UIButtonTypeCustom];
                tButton.tag = KMAlertViewHelperWordButtonTagPrefix + idx;
                [tButton addTarget:self action:@selector(helperWordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                tButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.f];
                [tButton setTitle:word forState:UIControlStateNormal];
                [tButton sizeToFit];
                setFrameWithWidth(tButton, SSWidth(tButton) + 20.f);
                
                UIBarButtonItem *tItem = [[UIBarButtonItem alloc] initWithCustomView:tButton];
                [mutItems addObject:tItem];
            }];
            
            _helperToolbar.items = [mutItems copy];
        }
        else {
            tFrame.size.height = 0.f;
            _helperToolbar.hidden = YES;
        }
    }
}

#pragma mark - Actions

- (void)buttonClicked:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(kmAlertView:clickedButtonAtIndex:)]) {
        [_delegate kmAlertView:self clickedButtonAtIndex:[_buttons indexOfObject:sender]];
    }
    
    [self dismissWithClickedButtonIndex:[_buttons indexOfObject:sender] animated:YES];
}

- (void)helperWordButtonClicked:(id)sender
{
    if (_dataSource && [_dataSource respondsToSelector:@selector(helperWordsInkmAlertView:)]) {
        NSArray *words = [_dataSource helperWordsInkmAlertView:self];
        UIButton *tButton = (UIButton *)sender;
        int idx = tButton.tag - KMAlertViewHelperWordButtonTagPrefix;
        
        if (idx < [words count]) {
            NSString *word = [words objectAtIndex:idx];
            
            if ([self textView:_textView shouldChangeTextInRange:_textView.selectedRange replacementText:word]) {
                [_textView insertString:word];
                [self handleUITextViewTextDidChangeNotification:nil];
            }
        }
    }
}

#pragma mark - UITextViewDelegate

- (void)handleUITextViewTextDidChangeNotification:(NSNotification *)notification
{
    [self refreshPlaceHolder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSInteger changedLength = [textView.text length] - range.length + [text length];
    return changedLength <= _maxCharacterCount;
}

#pragma mark - frames

- (CGRect)frameForDialogView
{
    CGFloat originX = self.defaultOffsetOrigin.x;
    CGFloat originY = self.defaultOffsetOrigin.y;
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        if (!CGPointEqualToPoint(_portraitOffsetOrigin, CGPointZero)) {
            originX = _portraitOffsetOrigin.x;
            originY = _portraitOffsetOrigin.y;
        }
        else if (!CGPointEqualToPoint(_offsetOrigin, CGPointZero)) {
            originX = _offsetOrigin.x;
            originY = _offsetOrigin.y;
        }
    }
    else {
        if (!CGPointEqualToPoint(_landscapeOffsetOrigin, CGPointZero)) {
            originX = _landscapeOffsetOrigin.x;
            originY = _landscapeOffsetOrigin.y;
        }
        else if (!CGPointEqualToPoint(_offsetOrigin, CGPointZero)) {
            originX = _offsetOrigin.x;
            originY = _offsetOrigin.y;
        }
    }
    
    CGRect dialogFrame = CGRectMake(originX, originY, self.defaultDialogWidth, self.defaultDialogHeight);
    return dialogFrame;
}

- (CGRect)frameForSelf
{
    CGFloat screenWidth = MIN(screenSize().width, screenSize().height);
    CGFloat screenHeight = MAX(screenSize().width, screenSize().height);
    CGRect frame = CGRectMake(0, 0, screenWidth, screenHeight);
    return frame;
}

#pragma mark - Class

+ (CGSize)applicationSize
{
    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;
    float width = 0, height = 0;
    if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        width = MAX(screenSize.width, screenSize.height);
        height = MIN(screenSize.width, screenSize.height);
    }
    else {
        width = MIN(screenSize.width, screenSize.height);
        height = MAX(screenSize.width, screenSize.height);
    }
    return CGSizeMake(width, height);
}

@end
