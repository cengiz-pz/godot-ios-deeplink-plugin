#
# © 2024-present https://github.com/cengiz-pz
#

@tool
extends EditorPlugin

const PLUGIN_NODE_TYPE_NAME: String = "Deeplink"
const PLUGIN_PARENT_NODE_TYPE: String = "Node"
const PLUGIN_NAME: String = "DeeplinkPlugin"
const PLUGIN_VERSION: String = "1.0"

const ENTITLEMENTS_FILE_HEADER: String = """<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.developer.associated-domains</key>
	<array>\n"""

const ENTITLEMENTS_FILE_FOOTER: String = """\t</array>
</dict>
</plist>\n"""
const EXPORT_FILE_SUFFIX: String = ".ipa"


var export_plugin: IosExportPlugin


func _enter_tree() -> void:
	add_custom_type(PLUGIN_NODE_TYPE_NAME, PLUGIN_PARENT_NODE_TYPE, preload("Deeplink.gd"), preload("icon.png"))
	export_plugin = IosExportPlugin.new()
	add_export_plugin(export_plugin)


func _exit_tree() -> void:
	remove_custom_type(PLUGIN_NODE_TYPE_NAME)
	remove_export_plugin(export_plugin)
	export_plugin = null


class IosExportPlugin extends EditorExportPlugin:
	var _plugin_name = PLUGIN_NAME
	var _export_path: String


	func _supports_platform(platform: EditorExportPlatform) -> bool:
		if platform is EditorExportPlatformIOS:
			return true
		return false


	func _get_name() -> String:
		return _plugin_name


	func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
		_export_path = path


	func _export_end() -> void:
		_regenerate_entitlements_file()


	func _regenerate_entitlements_file() -> void:
		if _export_path:
			if _export_path.ends_with(EXPORT_FILE_SUFFIX):
				var __project_path = ProjectSettings.globalize_path("res://")
				print("******** PROJECT PATH='%s'" % __project_path)
				var __directory_path = "%s%s" % [__project_path, _export_path.trim_suffix(EXPORT_FILE_SUFFIX)]
				if DirAccess.dir_exists_absolute(__directory_path):
					var __project_name = _get_project_name_from_path(__directory_path)
					var __file_path = "%s/%s.entitlements" % [__directory_path, __project_name]
					print("******** ENTITLEMENTS FILE PATH='%s'" % __file_path)
					if FileAccess.file_exists(__file_path):
						DirAccess.remove_absolute(__file_path)
					var __file = FileAccess.open(__file_path, FileAccess.WRITE)
					if __file:
						__file.store_string(ENTITLEMENTS_FILE_HEADER)

						var __deeplink_nodes: Array = _get_deeplink_nodes(EditorInterface.get_edited_scene_root())
						for __node in __deeplink_nodes:
							var __deeplink_node = __node as Deeplink
							__file.store_line("\t\t<string>applinks:%s</string>" % __deeplink_node.host)
							# As opposed to Android, in iOS __deeplink_node.scheme, __deeplink_node.path_prefix are
							# configured on the server side (apple-app-site-association file)

						__file.store_string(ENTITLEMENTS_FILE_FOOTER)
						__file.close()
					else:
						printerr("Couldn't open file '%s' for writing." % __file_path)
				else:
					printerr("Directory '%s' doesn't exist." % __directory_path)
			else:
				printerr("Unexpected export path '%s'" % _export_path)
		else:
			printerr("Export path is not defined.")


	func _get_project_name_from_path(a_path: String) -> String:
		var __result = ""

		var __split = a_path.rsplit("/", false, 1)
		if __split.size() > 1:
			__result = __split[1]

		return __result


	func _get_deeplink_nodes(a_node: Node) -> Array:
		var __result: Array = []

		if a_node is Deeplink:
			__result.append(a_node)

		if a_node.get_child_count() > 0:
			for __child in a_node.get_children():
				__result.append_array(_get_deeplink_nodes(__child))

		return __result
