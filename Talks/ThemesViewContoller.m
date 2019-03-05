//
//  ThemesViewContoller.m
//  Talks
//
//  Created by Denis Garifyanov on 03/03/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

#import "ThemesViewContoller.h"
#import "Talks-Swift.h"


@interface ThemesViewContoller ()


@end

@implementation ThemesViewContoller

- (id)init {
    self = [super init];
    if (self) {
        self.themes.theme1 = UIColor.blueColor;
        self.themes.theme2 = UIColor.brownColor;
        self.themes.theme3 = UIColor.cyanColor;
    }
    return self;
}



- (IBAction)theme1:(id)sender {
    self.view.backgroundColor = self.themes.theme1;
}
- (IBAction)theme2:(id)sender {
    self.view.backgroundColor = self.themes.theme2;
}
- (IBAction)theme3:(id)sender {
    self.view.backgroundColor = self.themes.theme3;
}
- (IBAction)doneButtonTapped:(id)sender {
        printf("\n dismissed");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}



- (void)viewDidLoad {
    [super viewDidLoad];
    printf("View was loaded");

    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)themesViewController:(nonnull ThemesViewController *)controller didSelectTheme:(nonnull UIColor *)selectedTheme {
    printf("somthing gonna happing");
}

@end
