//
// © 2024-present https://github.com/cengiz-pz
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "deeplink_plugin_implementation.h"
#import "deeplink_service.h"
#import "gdp_converter.h"


String const DEEPLINK_RECEIVED_SIGNAL = "deeplink_received";

DeeplinkPlugin* DeeplinkPlugin::instance = NULL;
NSURL* DeeplinkPlugin::receivedUrl;


void DeeplinkPlugin::_bind_methods() {
	ClassDB::bind_method(D_METHOD("initialize"), &DeeplinkPlugin::initialize);
	ClassDB::bind_method(D_METHOD("get_url"), &DeeplinkPlugin::get_url);
	ClassDB::bind_method(D_METHOD("get_scheme"), &DeeplinkPlugin::get_scheme);
	ClassDB::bind_method(D_METHOD("get_host"), &DeeplinkPlugin::get_host);
	ClassDB::bind_method(D_METHOD("get_path"), &DeeplinkPlugin::get_path);
	ClassDB::bind_method(D_METHOD("clear_data"), &DeeplinkPlugin::clear_data);

	ADD_SIGNAL(MethodInfo(DEEPLINK_RECEIVED_SIGNAL, PropertyInfo(Variant::DICTIONARY, "url_data"), PropertyInfo(Variant::DICTIONARY, "options_data")));
}

Error DeeplinkPlugin::initialize() {
	NSLog(@"DeeplinkPlugin initialize");

	if (initialized) {
		NSLog(@"DeeplinkPlugin already initialized");
		return FAILED;
	}

	if (receivedUrl) {
		emit_signal(DEEPLINK_RECEIVED_SIGNAL, [GDPConverter nsUrlToGodotDictionary:receivedUrl]);
	}

	initialized = true;

	return OK;
}

String DeeplinkPlugin::get_url() {
	String result = "";

	if (receivedUrl) {
		result = [GDPConverter nsStringToGodotString:receivedUrl.absoluteString];
	}

	return result;
}

String DeeplinkPlugin::get_scheme() {
	String result = "";

	if (receivedUrl) {
		result = [GDPConverter nsStringToGodotString:receivedUrl.scheme];
	}

	return result;
}

String DeeplinkPlugin::get_host() {
	String result = "";

	if (receivedUrl) {
		result = [GDPConverter nsStringToGodotString:receivedUrl.host];
	}

	return result;
}

String DeeplinkPlugin::get_path() {
	String result = "";

	if (receivedUrl) {
		result = [GDPConverter nsStringToGodotString:receivedUrl.path];
	}

	return result;
}

void DeeplinkPlugin::clear_data() {
	receivedUrl = NULL;
}

void DeeplinkPlugin::navigate_to_open_by_default_settings() {
	// if (@available(iOS 18.3, *)) {
	// 	// Create the URL that deep links to your app's custom settings.
	// 	NSURL *url = [[NSURL alloc] initWithString:UIApplicationOpenDefaultApplicationsSettingsURLString];
	// 	// Ask the system to open that URL.
	// 	[[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
	// }
	// else {
	// 	NSLog(@"DeeplinkPlugin::navigate_to_open_by_default_settings: ERROR: iOS version 18.3 or greater is required!");
	// }
	if (@available(iOS 8.0, *)) {
		// Create the URL that deep links to your app's custom settings.
		NSURL *url = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
		// Ask the system to open that URL.
		[[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
	}
	else {
		NSLog(@"DeeplinkPlugin::navigate_to_open_by_default_settings: ERROR: iOS version 8.0 or greater is required!");
	}
}

DeeplinkPlugin* DeeplinkPlugin::get_singleton() {
	return instance;
}

DeeplinkPlugin::DeeplinkPlugin() {
	NSLog(@"DeeplinkPlugin constructor");

	ERR_FAIL_COND(instance != NULL);
	instance = this;

	initialized = false;
}

DeeplinkPlugin::~DeeplinkPlugin() {
	NSLog(@"DeeplinkPlugin destructor");

	if (instance == this) {
		instance = NULL;
	}
}
