//
// © 2024-present https://github.com/cengiz-pz
//

#import "deeplink_service.h"
#import "deeplink_plugin_implementation.h"
#import "gdp_converter.h"


@implementation DeeplinkService

- (BOOL) application:(UIApplication*) app openURL:(NSURL*) url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id>*) options {
	
	DeeplinkPlugin::get_singleton()->emit_signal(URL_OPENED_SIGNAL, [GDPConverter nsUrlToGodotDictionary:url],
				[GDPConverter nsDictionaryToGodotDictionary:options]);

	return YES;
}

@end
