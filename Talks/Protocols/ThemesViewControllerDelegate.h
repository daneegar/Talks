//
//  ThemesViewControllerDelegate.h
//  Talks
//
//  Created by Denis Garifyanov on 03/03/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ThemesViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol ThemesViewControllerDelegate <NSObject>

@required
    - (void) themesViewController: (ThemesViewController *)controller didSelectTheme:(UIColor *)selectedTheme;
@end

NS_ASSUME_NONNULL_END
