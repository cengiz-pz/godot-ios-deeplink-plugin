//
// © 2024-present https://github.com/cengiz-pz
//

#import <Foundation/Foundation.h>

#import "deeplink_plugin_implementation.h"
#import "deeplink_service.h"
#import "gdp_converter.h"


String const DEEPLINK_RECEIVED_SIGNAL = "deeplink_received";

DeeplinkPlugin* DeeplinkPlugin::instance = NULL;


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

	initialized = true;
	return OK;
}

String DeeplinkPlugin::get_url() {
	String result = "";

	if (this->receivedUrl) {
		result = [GDPConverter nsStringToGodotString:this->receivedUrl.absoluteString];
	}

	return result;
}

String DeeplinkPlugin::get_scheme() {
	String result = "";

	if (this->receivedUrl) {
		result = [GDPConverter nsStringToGodotString:this->receivedUrl.scheme];
	}

	return result;
}

String DeeplinkPlugin::get_host() {
	String result = "";

	if (this->receivedUrl) {
		result = [GDPConverter nsStringToGodotString:this->receivedUrl.host];
	}

	return result;
}

String DeeplinkPlugin::get_path() {
	String result = "";

	if (this->receivedUrl) {
		result = [GDPConverter nsStringToGodotString:this->receivedUrl.path];
	}

	return result;
}

void DeeplinkPlugin::clear_data() {
	this->receivedUrl = NULL;
}

void DeeplinkPlugin::set_received_url(NSURL* url) {
	this->receivedUrl = url;
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
