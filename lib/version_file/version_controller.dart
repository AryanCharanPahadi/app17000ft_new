import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

import '../components/custom_confirmation.dart';

class VersionController extends GetxController {
  var version = ''.obs;
  var isLoading = false.obs;
var currentVersion = 4.0;
  @override
  void onInit() {
    super.onInit();
    fetchVersion();
  }

  // Fetch version from API
  Future<void> fetchVersion() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse('https://mis.17000ft.org/apis/fast_apis/version.php'));

      // Debugging: Log status code and response body for visibility
      print('Status Code: ${response.statusCode}');
      print('Response body: ${response.body}');  // Full response body for debugging

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // Ensure the 'version' field exists in the response
        if (data.containsKey('version')) {
          version.value = data['version'] ?? '';
          print('Version from API: ${version.value}');  // Debugging: Check API version value

          // Store the version locally
          await _storeVersion(version.value);

          // Convert version to double for comparison
          double apiVersion = double.tryParse(version.value) ?? 0.0;
          print('Parsed version as double: $apiVersion');  // Debugging: Check the double conversion

          // Check if the version is not equal to 4.0
          if (apiVersion != currentVersion) {
            print('API version is not $currentVersion, showing upgrade prompt.');
            showUpgradePrompt();
          } else {
            print('Version is $currentVersion, no upgrade prompt needed.');
          }
        } else {
          print('Error: API response does not contain "version" field.');
        }
      } else {
        // Handle errors: Non-200 status codes
        print('Error: Failed to fetch version, Status code: ${response.statusCode}, Body: ${response.body}');
        // Get.snackbar('Error', 'Failed to fetch version');
        await _loadVersion();  // Attempt to load version from local storage if API fails
      }
    } catch (e) {
      // Handle exceptions (e.g., network issues)
      print('Exception: $e');  // Debugging: Print the exception message
      // Get.snackbar('Error', 'An error occurred: $e');
      await _loadVersion();  // Load version from local storage in case of error
    } finally {
      isLoading(false);
    }
  }

  // Store version in SharedPreferences
  Future<void> _storeVersion(String version) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_version', version);
      print('Stored version locally: $version');
    } catch (e) {
      print('Error storing version locally: $e');
    }
  }

  // Load version from SharedPreferences
  Future<void> _loadVersion() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedVersion = prefs.getString('app_version');
      if (savedVersion != null) {
        version.value = savedVersion;
        print('Loaded version from local storage: $savedVersion');
      } else {
        print('No version found in local storage.');
      }
    } catch (e) {
      print('Error loading version from local storage: $e');
    }
  }

  // Show an upgrade prompt dialog
  void showUpgradePrompt() {
    if (Get.isDialogOpen != true) {  // Ensure only one dialog is open
      Get.dialog(
        Confirmation(
          title: "Update Available",
          desc: "A new version of the app is available. Please update to the latest version.",
          onPressed: () {
            print("Navigating to update...");  // Debugging: Handle the upgrade action
            // TODO: Add actual navigation logic for updating the app
          },
          yes: "OK",
          iconname: Icons.update, // Display update icon in dialog
        ),
      );
    }
  }
}
