gen-build:
	flutter pub run build_runner build

gen-delete:
	flutter pub run build_runner build --delete-conflicting-outputs

# Clean build_runner cache
clean:
	flutter pub run build_runner clean

# Delete generated files manually (optional helper)
reset:
	rm -rf $(OUTPUT_DIR)/objectbox.g.dart
	rm -rf $(OUTPUT_DIR)/objectbox-model.json
	rm -rf .dart_tool/build
