//
//  ThemesViewContoller.h
//  Talks
//
//  Created by Denis Garifyanov on 03/03/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemesViewControllerDelegate.h"
#import "Themes.h"
#import "Talks-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThemesViewContoller : UIViewController
@property (nonatomic, strong) ConversationListViewController* delegate;
@property (nonatomic, strong) Themes *themes;
- (id) init;

@end

NS_ASSUME_NONNULL_END
