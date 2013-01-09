KYArcTab
========

Arcuated tab view controller with toggleing animation, 2 ~ 4 tabs are enabled. What's more, you can swipe left or right to toggle the views.

![](https://raw.github.com/Kjuly/KYArcTab/dev/DemoScreenshot/demo_screenshot.png)

# Usage

Subclass `KYArcTabViewController` and override the `-setup` message to configure the child view controllers.

Then use the designated initializer below to initialize the tab view controller when you need:

    - (id)  initWithTitle:(NSString *)title                // title
               tabBarSize:(CGSize)tabBarSize               // size of tab bar
    tabBarBackgroundColor:(UIColor *)tabBarBackgroundColor // background color of tab bar
                 itemSize:(CGSize)itemSize                 // size of items on tab bar
                    arrow:(UIImage *)arrow;                // arrow on the tab bar

---
# License

This code is distributed under the terms and conditions of the MIT license.

