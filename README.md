KYArcTab
========

Arcuated tab view controller with toggleing animation, 2 ~ 4 tabs are enabled. What's more, you can swipe left or right to toggle the views.

![](https://raw.github.com/Kjuly/KYArcTab/dev/DemoScreenshot/demo_screenshot.png)

# Usage

Create `KYArcTabViewController` instance, then set content viewControllers

	KYArcTabViewController *arcTabViewController = [[KYArcTabViewController alloc] init];
	arcTabViewController.viewControllers = viewControllers;

Set arcTabItem to set the tab icon

	contentViewController.arcTabItem = [[KYArcTabItem alloc] initWithTitle:nil image:image selectedImage:nil];

---
# License

This code is distributed under the terms and conditions of the MIT license.

