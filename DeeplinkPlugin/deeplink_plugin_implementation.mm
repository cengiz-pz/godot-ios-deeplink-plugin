//
// © 2024-present https://github.com/cengiz-pz
//

#import <Foundation/Foundation.h>

#import "deeplink_plugin_implementation.h"
#import "deeplink_service.h"


String const URL_OPENED_SIGNAL = "url_opened";

DeeplinkPlugin* DeeplinkPlugin::instance = NULL;


void DeeplinkPlugin::_bind_methods() {
	ClassDB::bind_method(D_METHOD("initialize"), &DeeplinkPlugin::initialize);

	ADD_SIGNAL(MethodInfo(URL_OPENED_SIGNAL, PropertyInfo(Variant::DICTIONARY, "url_data"), PropertyInfo(Variant::DICTIONARY, "options_data")));
}

Error DeeplinkPlugin::initialize() {
	NSLog(@"DeeplinkPlugin initialize");

	if (initialized) {
		NSLog(@"DeeplinkPlugin already initialized");
		return FAILED;
	}

	initialized = true;
	return OK;
}

DeeplinkPlugin* DeeplinkPlugin::get_singleton() {
	return instance;
}

DeeplinkPlugin::DeeplinkPlugin() {
	NSLog(@"DeeplinkPlugin constructor");

	[GodotApplicalitionDelegate addService:[DeeplinkService alloc]];

	ERR_FAIL_COND(instance != NULL);
	instance = this;

	initialized = true;
}

DeeplinkPlugin::~DeeplinkPlugin() {
	NSLog(@"DeeplinkPlugin destructor");
	if (instance == this) {
		instance = NULL;
	}
}
