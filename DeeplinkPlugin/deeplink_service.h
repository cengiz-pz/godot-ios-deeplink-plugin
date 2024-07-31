//
// © 2024-present https://github.com/cengiz-pz
//

#ifndef deeplink_plugin_application_delegate_h
#define deeplink_plugin_application_delegate_h

#import <UIKit/UIKit.h>
#import "app_delegate.h"
#import "godot_app_delegate.h"

@interface DeeplinkService : ApplicationDelegateService 

- (BOOL) application:(UIApplication*) app openURL:(NSURL*) url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id>*) options;

@end

#endif /* deeplink_plugin_application_delegate_h */
