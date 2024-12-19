#
# © 2024-present https://github.com/cengiz-pz
#

@tool
class_name Deeplink
extends Node

signal deeplink_received(url: DeeplinkUrl)

const PLUGIN_SINGLETON_NAME: String = "DeeplinkPlugin"

@export_category("Link")
@export var label: String = ""
@export var is_auto_verify: bool = true
@export_category("Link Category")
@export var is_default: bool = true
@export var is_browsable: bool = true
@export_category("Link Data")
@export var scheme: String = "https"
@export var host: String = ""
@export var path_prefix: String = ""

var _plugin_singleton: Object


func _ready() -> void:
	_update_plugin()


func _notification(a_what: int) -> void:
	if a_what == NOTIFICATION_APPLICATION_RESUMED:
		_update_plugin()


func _update_plugin() -> void:
	if _plugin_singleton == null:
		if Engine.has_singleton(PLUGIN_SINGLETON_NAME):
			_plugin_singleton = Engine.get_singleton(PLUGIN_SINGLETON_NAME)
			_connect_signals()
		else:
			printerr("%s singleton not found!" % PLUGIN_SINGLETON_NAME)


func _connect_signals() -> void:
	_plugin_singleton.connect("url_opened", _on_url_opened)


func _on_url_opened(url_data: Dictionary) -> void:
	deeplink_received.emit(DeeplinkUrl.new(url_data))


# Only supported for Android platform
func is_domain_associated(a_domain: String) -> bool:
	var __result = true

	if _plugin_singleton != null:
		if _plugin_singleton.has_method("is_domain_associated"):
			__result = _plugin_singleton.is_domain_associated(a_domain)
		else:
			printerr("%s.%s() method not implemented for current platform" % [PLUGIN_SINGLETON_NAME, "is_domain_associated"])
	else:
		printerr("%s plugin not initialized" % PLUGIN_SINGLETON_NAME)

	return __result


# Only supported for Android platform
func navigate_to_open_by_default_settings() -> void:
	if _plugin_singleton != null:
		if _plugin_singleton.has_method("navigate_to_open_by_default_settings"):
			_plugin_singleton.navigate_to_open_by_default_settings()
		else:
			printerr("%s.%s() method not implemented for current platform" % [PLUGIN_SINGLETON_NAME, "navigate_to_open_by_default_settings"])
	else:
		printerr("%s plugin not initialized" % PLUGIN_SINGLETON_NAME)


func get_link_url() -> String:
	var __result = ""

	if _plugin_singleton != null:
		__result = _plugin_singleton.get_url()
	else:
		printerr("%s plugin not initialized" % PLUGIN_SINGLETON_NAME)

	return __result


func get_link_scheme() -> String:
	var __result = ""

	if _plugin_singleton != null:
		__result = _plugin_singleton.get_scheme()
	else:
		printerr("%s plugin not initialized" % PLUGIN_SINGLETON_NAME)

	return __result


func get_link_host() -> String:
	var __result = ""

	if _plugin_singleton != null:
		__result = _plugin_singleton.get_host()
	else:
		printerr("%s plugin not initialized" % PLUGIN_SINGLETON_NAME)

	return __result


func get_link_path() -> String:
	var __result = ""

	if _plugin_singleton != null:
		__result = _plugin_singleton.get_path()
	else:
		printerr("%s plugin not initialized" % PLUGIN_SINGLETON_NAME)

	return __result


func clear_data() -> void:
	if _plugin_singleton != null:
		_plugin_singleton.clear_data()
	else:
		printerr("%s plugin not initialized" % PLUGIN_SINGLETON_NAME)
