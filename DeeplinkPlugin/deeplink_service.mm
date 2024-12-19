//
// © 2024-present https://github.com/cengiz-pz
//

#import "deeplink_service.h"
#import "deeplink_plugin_implementation.h"
#import "gdp_converter.h"


@implementation DeeplinkService

- (BOOL) application:(UIApplication*) app openURL:(NSURL*) url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id>*) options {

	DeeplinkPlugin::get_singleton()->set_received_url(url);
	DeeplinkPlugin::get_singleton()->emit_signal(URL_OPENED_SIGNAL, [GDPConverter nsUrlToGodotDictionary:url],
				[GDPConverter nsDictionaryToGodotDictionary:options]);

	return YES;
}

- (BOOL) application:(UIApplication*) app continueUserActivity:(NSUserActivity*) userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>>* restorableObjects)) restorationHandler {
	if ([userActivity.activityType isEqualToString: NSUserActivityTypeBrowsingWeb]) {
        NSURL* url = userActivity.webpageURL;
		DeeplinkPlugin::get_singleton()->set_received_url(url);
		DeeplinkPlugin::get_singleton()->emit_signal(URL_OPENED_SIGNAL, [GDPConverter nsUrlToGodotDictionary:url], Dictionary());
    }

    return YES;
}

@end
