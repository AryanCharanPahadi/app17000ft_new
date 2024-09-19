import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:app17000ft_new/constants/color_const.dart';

import 'package:app17000ft_new/helper/database_helper.dart';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';


import '../../base_client/baseClient_controller.dart';

import 'package:app17000ft_new/forms/issue_tracker/issue_tracker_modal.dart';
import 'package:app17000ft_new/forms/issue_tracker/lib_issue_modal.dart';

import 'package:app17000ft_new/forms/issue_tracker/playground_issue.dart';

import 'package:flutter/cupertino.dart';

import 'alexa_issue.dart';
import 'digilab_issue.dart';
import 'furniture_issue.dart';

class IssueTrackerController extends GetxController with BaseController {
  var counterText = ''.obs;

  String? _tourValue;
  String? get tourValue => _tourValue;

  String? _schoolValue;
  String? get schoolValue => _schoolValue;

  bool isLoading = false;

  final TextEditingController correctUdiseCodeController = TextEditingController();
  final TextEditingController libraryDescriptionController = TextEditingController();
  final TextEditingController playgroundDescriptionController = TextEditingController();
  final TextEditingController digiLabDescriptionController = TextEditingController();
  final TextEditingController classroomDescriptionController = TextEditingController();
  final TextEditingController alexaDescriptionController = TextEditingController();
  final TextEditingController otherSolarDescriptionController = TextEditingController();
  final TextEditingController tabletNumberController = TextEditingController();
  final TextEditingController dotDeviceMissingController = TextEditingController();
  final TextEditingController dotDeviceNotConfiguredController = TextEditingController();
  final TextEditingController dotDeviceNotConnectingController = TextEditingController();
  final TextEditingController dotDeviceNotChargingController = TextEditingController();
  final TextEditingController dotOtherIssueController = TextEditingController();
  final TextEditingController tabletNumber3Controller = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController dateController2 = TextEditingController();
  final TextEditingController dateController3 = TextEditingController();
  final TextEditingController dateController4 = TextEditingController();
  final TextEditingController dateController5 = TextEditingController();
  final TextEditingController dateController6 = TextEditingController();
  final TextEditingController dateController7 = TextEditingController();
  final TextEditingController dateController8 = TextEditingController();
  final TextEditingController dateController9 = TextEditingController();
  final TextEditingController dateController10 = TextEditingController();


  final FocusNode _tourIdFocusNode = FocusNode();
  FocusNode get tourIdFocusNode => _tourIdFocusNode;

  final FocusNode _schoolFocusNode = FocusNode();
  FocusNode get schoolFocusNode => _schoolFocusNode;

  List<IssueTrackerRecords> _issueTrackerList = [];
  List<IssueTrackerRecords> get issueTrackerList => _issueTrackerList;


  // Lib issue list
  List<LibIssue> _libIssueList = [];
  List<LibIssue> get libIssueList => _libIssueList;

  // Play issue list
  List<PlaygroundIssue> _playgroundIssueList = [];
  List<PlaygroundIssue> get playgroundIssueList => _playgroundIssueList;

  //digilab issue list
  List<DigiLabIssue> _digiLabIssueList = [];
  List<DigiLabIssue> get digiLabIssueList => _digiLabIssueList;

  //furniture issue list
  List<FurnitureIssue> _furnitureIssueList = [];
  List<FurnitureIssue> get furnitureIssueList => _furnitureIssueList;

  //alexa issue list
  List<AlexaIssue> _alexaIssueList = [];
  List<AlexaIssue> get alexaIssueList => _alexaIssueList;


  List<String> _staffNames = [];
  List<String> get staffNames => _staffNames;


  final List<XFile> _multipleImage = [];
  List<XFile> get multipleImage => _multipleImage;
  List<String> _imagePaths = [];
  List<String> get imagePaths => _imagePaths;
  // This will hold the converted list of File objects
  List<File> _imageFiles = [];
  List<File> get imageFiles => _imageFiles;


  final List<XFile> _multipleImage2 = [];
  List<XFile> get multipleImage2 => _multipleImage2;
  List<String> _imagePaths2 = [];
  List<String> get imagePaths2 => _imagePaths2;
  List<File> _imageFiles2 = [];
  List<File> get imageFiles2 => _imageFiles2;


  final List<XFile> _multipleImage3 = [];
  List<XFile> get multipleImage3 => _multipleImage3;
  List<String> _imagePaths3 = [];
  List<String> get imagePaths3 => _imagePaths3;
  List<File> _imageFiles3 = [];
  List<File> get imageFiles3 => _imageFiles3;

  final List<XFile> _multipleImage4 = [];
  List<XFile> get multipleImage4 => _multipleImage4;
  List<String> _imagePaths4 = [];
  List<String> get imagePaths4 => _imagePaths4;
  List<File> _imageFiles4 = [];
  List<File> get imageFiles4 => _imageFiles4;


  final List<XFile> _multipleImage5 = [];
  List<XFile> get multipleImage5 => _multipleImage5;
  List<String> _imagePaths5 = [];
  List<String> get imagePaths5 => _imagePaths5;
  List<File> _imageFiles5 = [];
  List<File> get imageFiles5 => _imageFiles5;

  // Convert a File to Base64 String
  Future<List<String>> convertImagesToBase64() async {
    List<String> base64Images = [];

    for (var image in _imageFiles) { // _imageFiles is the list of File objects
      final bytes = await image.readAsBytes();
      base64Images.add(base64Encode(bytes));
    }
    return base64Images;
  }

  // Convert a File to Base64 String
  Future<List<String>> convertImagesToBase64_2() async {
    List<String> base64Images2 = [];

    for (var image in _imageFiles2) { // _imageFiles is the list of File objects
      final bytes = await image.readAsBytes();
      base64Images2.add(base64Encode(bytes));
    }
    return base64Images2;
  }

  // Convert a File to Base64 String
  Future<List<String>> convertImagesToBase64_3() async {
    List<String> base64Images3 = [];

    for (var image in _imageFiles3) { // _imageFiles is the list of File objects
      final bytes = await image.readAsBytes();
      base64Images3.add(base64Encode(bytes));
    }
    return base64Images3;
  }

// Convert a File to Base64 String
  Future<List<String>> convertImagesToBase64_4() async {
    List<String> base64Images4 = [];

    for (var image in _imageFiles4) { // _imageFiles is the list of File objects
      final bytes = await image.readAsBytes();
      base64Images4.add(base64Encode(bytes));
    }
    return base64Images4;
  }

  // Convert a File to Base64 String
  Future<List<String>> convertImagesToBase64_5() async {
    List<String> base64Images5 = [];

    for (var image in _imageFiles5) { // _imageFiles is the list of File objects
      final bytes = await image.readAsBytes();
      base64Images5.add(base64Encode(bytes));
    }
    return base64Images5;
  }


  // Method to capture or pick photos
  Future<String> takePhoto(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    _multipleImage.clear();  // Clear the existing images
    _imagePaths = [];
    _imageFiles = [];  // Clear the converted File objects

    // Helper function to resize and compress image
    Future<File?> processImage(File file) async {
      final img.Image? image = img.decodeImage(await file.readAsBytes());
      if (image == null) return null;

      // Resize the image to a smaller width while maintaining aspect ratio
      final img.Image resized = img.copyResize(image, width: 800);  // Adjust width as needed
      final List<int> compressedImage = img.encodeJpg(resized, quality: 80);  // Adjust quality as needed

      // Save the processed image to a new file
      final String newPath = file.path.replaceAll('.jpg', '_processed.jpg');
      final File newFile = File(newPath)..writeAsBytesSync(compressedImage);
      return newFile;
    }

    if (source == ImageSource.gallery) {
      final selectedImages = await picker.pickMultiImage();
      if (selectedImages != null) {
        for (XFile xfile in selectedImages) {
          File originalFile = File(xfile.path);
          File? processedFile = await processImage(originalFile);
          if (processedFile != null) {
            _multipleImage.add(XFile(processedFile.path));
            _imagePaths.add(processedFile.path);
            _imageFiles.add(processedFile);
          }
        }
      }
    } else if (source == ImageSource.camera) {
      final pickedImage = await picker.pickImage(source: source);
      if (pickedImage != null) {
        File originalFile = File(pickedImage.path);
        File? processedFile = await processImage(originalFile);
        if (processedFile != null) {
          _multipleImage.add(XFile(processedFile.path));
          _imagePaths.add(processedFile.path);
          _imageFiles.add(processedFile);
        }
      }
    }
    update();
    return _imagePaths.toString();
  }

// Method to capture or pick photos

// Method to capture or pick photos
  Future<String> takePhoto2(ImageSource source) async {
    final ImagePicker picker2 = ImagePicker();
    _multipleImage2.clear();  // Clear the existing images
    _imagePaths2 = [];
    _imageFiles2 = [];  // Clear the converted File objects

    // Helper function to resize and compress image
    Future<File?> processImage(File file) async {
      final img.Image? image = img.decodeImage(await file.readAsBytes());
      if (image == null) return null;

      // Resize the image to a smaller width while maintaining aspect ratio
      final img.Image resized = img.copyResize(image, width: 800);  // Adjust width as needed
      final List<int> compressedImage = img.encodeJpg(resized, quality: 80);  // Adjust quality as needed

      // Save the processed image to a new file
      final String newPath = file.path.replaceAll('.jpg', '_processed.jpg');
      final File newFile = File(newPath)..writeAsBytesSync(compressedImage);
      return newFile;
    }

    if (source == ImageSource.gallery) {
      final selectedImages2 = await picker2.pickMultiImage();
      if (selectedImages2 != null) {
        for (XFile xfile in selectedImages2) {
          File originalFile = File(xfile.path);
          File? processedFile = await processImage(originalFile);
          if (processedFile != null) {
            _multipleImage2.add(XFile(processedFile.path));
            _imagePaths2.add(processedFile.path);
            _imageFiles2.add(processedFile);
          }
        }
      }
    } else if (source == ImageSource.camera) {
      final pickedImage2 = await picker2.pickImage(source: source);
      if (pickedImage2 != null) {
        File originalFile = File(pickedImage2.path);
        File? processedFile = await processImage(originalFile);
        if (processedFile != null) {
          _multipleImage2.add(XFile(processedFile.path));
          _imagePaths2.add(processedFile.path);
          _imageFiles2.add(processedFile);
        }
      }
    }
    update();
    return _imagePaths2.toString();
  }


  Future<String> takePhoto3(ImageSource source) async {
    final ImagePicker picker3 = ImagePicker();
    _multipleImage3.clear();  // Clear the existing images
    _imagePaths3 = [];
    _imageFiles3 = [];  // Clear the converted File objects

    // Helper function to resize and compress image
    Future<File?> processImage(File file) async {
      final img.Image? image = img.decodeImage(await file.readAsBytes());
      if (image == null) return null;

      // Resize the image to a smaller width while maintaining aspect ratio
      final img.Image resized = img.copyResize(image, width: 800);  // Adjust width as needed
      final List<int> compressedImage = img.encodeJpg(resized, quality: 80);  // Adjust quality as needed

      // Save the processed image to a new file
      final String newPath = file.path.replaceAll('.jpg', '_processed.jpg');
      final File newFile = File(newPath)..writeAsBytesSync(compressedImage);
      return newFile;
    }

    if (source == ImageSource.gallery) {
      final selectedImages3 = await picker3.pickMultiImage();
      if (selectedImages3 != null) {
        for (XFile xfile in selectedImages3) {
          File originalFile = File(xfile.path);
          File? processedFile = await processImage(originalFile);
          if (processedFile != null) {
            _multipleImage3.add(XFile(processedFile.path));
            _imagePaths3.add(processedFile.path);
            _imageFiles3.add(processedFile);
          }
        }
      }
    } else if (source == ImageSource.camera) {
      final pickedImage3 = await picker3.pickImage(source: source);
      if (pickedImage3 != null) {
        File originalFile = File(pickedImage3.path);
        File? processedFile = await processImage(originalFile);
        if (processedFile != null) {
          _multipleImage3.add(XFile(processedFile.path));
          _imagePaths3.add(processedFile.path);
          _imageFiles3.add(processedFile);
        }
      }
    }
    update();
    return _imagePaths3.toString();
  }

  Future<String> takePhoto4(ImageSource source) async {
    final ImagePicker picker4 = ImagePicker();
    _multipleImage4.clear();  // Clear the existing images
    _imagePaths4 = [];
    _imageFiles4 = [];  // Clear the converted File objects

    // Helper function to resize and compress image
    Future<File?> processImage(File file) async {
      final img.Image? image = img.decodeImage(await file.readAsBytes());
      if (image == null) return null;

      // Resize the image to a smaller width while maintaining aspect ratio
      final img.Image resized = img.copyResize(image, width: 800);  // Adjust width as needed
      final List<int> compressedImage = img.encodeJpg(resized, quality: 80);  // Adjust quality as needed

      // Save the processed image to a new file
      final String newPath = file.path.replaceAll('.jpg', '_processed.jpg');
      final File newFile = File(newPath)..writeAsBytesSync(compressedImage);
      return newFile;
    }

    if (source == ImageSource.gallery) {
      final selectedImages4 = await picker4.pickMultiImage();
      if (selectedImages4 != null) {
        for (XFile xfile in selectedImages4) {
          File originalFile = File(xfile.path);
          File? processedFile = await processImage(originalFile);
          if (processedFile != null) {
            _multipleImage4.add(XFile(processedFile.path));
            _imagePaths4.add(processedFile.path);
            _imageFiles4.add(processedFile);
          }
        }
      }
    } else if (source == ImageSource.camera) {
      final pickedImage4 = await picker4.pickImage(source: source);
      if (pickedImage4 != null) {
        File originalFile = File(pickedImage4.path);
        File? processedFile = await processImage(originalFile);
        if (processedFile != null) {
          _multipleImage4.add(XFile(processedFile.path));
          _imagePaths4.add(processedFile.path);
          _imageFiles4.add(processedFile);
        }
      }
    }
    update();
    return _imagePaths4.toString();
  }


// Method to capture or pick photos
  Future<String> takePhoto5(ImageSource source) async {
    final ImagePicker picker5 = ImagePicker();
    _multipleImage5.clear();  // Clear the existing images
    _imagePaths5 = [];
    _imageFiles5 = [];  // Clear the converted File objects

    // Helper function to resize and compress image
    Future<File?> processImage(File file) async {
      final img.Image? image = img.decodeImage(await file.readAsBytes());
      if (image == null) return null;

      // Resize the image to a smaller width while maintaining aspect ratio
      final img.Image resized = img.copyResize(image, width: 800);  // Adjust width as needed
      final List<int> compressedImage = img.encodeJpg(resized, quality: 80);  // Adjust quality as needed

      // Save the processed image to a new file
      final String newPath = file.path.replaceAll('.jpg', '_processed.jpg');
      final File newFile = File(newPath)..writeAsBytesSync(compressedImage);
      return newFile;
    }

    if (source == ImageSource.gallery) {
      final selectedImages5 = await picker5.pickMultiImage();
      if (selectedImages5 != null) {
        for (XFile xfile in selectedImages5) {
          File originalFile = File(xfile.path);
          File? processedFile = await processImage(originalFile);
          if (processedFile != null) {
            _multipleImage5.add(XFile(processedFile.path));
            _imagePaths5.add(processedFile.path);
            _imageFiles5.add(processedFile);
          }
        }
      }
    } else if (source == ImageSource.camera) {
      final pickedImage5 = await picker5.pickImage(source: source);
      if (pickedImage5 != null) {
        File originalFile = File(pickedImage5.path);
        File? processedFile = await processImage(originalFile);
        if (processedFile != null) {
          _multipleImage5.add(XFile(processedFile.path));
          _imagePaths5.add(processedFile.path);
          _imageFiles5.add(processedFile);
        }
      }
    }
    update();
    return _imagePaths5.toString();
  }


  void setSchool(String? value) {
    _schoolValue = value;
    update();
  }

  void setTour(String? value) {
    _tourValue = value;
    update();
  }





  Widget bottomSheet(BuildContext context) {
    return Container(
      color: AppColors.primary,
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text("Select Image", style: TextStyle(fontSize: 20.0, color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto(ImageSource.gallery);
                  Get.back();
                },
                child: const Text('Gallery', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomSheet2(BuildContext context) {
    return Container(
      color: AppColors.primary,
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text("Select Image", style: TextStyle(fontSize: 20.0, color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto2(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto2(ImageSource.gallery);
                  Get.back();
                },
                child: const Text('Gallery', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomSheet3(BuildContext context) {
    return Container(
      color: AppColors.primary,
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text("Select Image", style: TextStyle(fontSize: 20.0, color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto3(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto3(ImageSource.gallery);
                  Get.back();
                },
                child: const Text('Gallery', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomSheet4(BuildContext context) {
    return Container(
      color: AppColors.primary,
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text("Select Image", style: TextStyle(fontSize: 20.0, color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto4(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto4(ImageSource.gallery);
                  Get.back();
                },
                child: const Text('Gallery', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomSheet5(BuildContext context) {
    return Container(
      color: AppColors.primary,
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text("Select Image", style: TextStyle(fontSize: 20.0, color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto5(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto5(ImageSource.gallery);
                  Get.back();
                },
                child: const Text('Gallery', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showImagePreview(String imagePath, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.file(File(imagePath), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }

  void showImagePreview2(String imagePath2, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.file(File(imagePath2), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }

  void showImagePreview3(String imagePath3, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.file(File(imagePath3), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }


  void showImagePreview4(String imagePath4, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.file(File(imagePath4), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }


  void showImagePreview5(String imagePath5, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.file(File(imagePath5), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }

  void clearFields() {
    _tourValue = null;
    _schoolValue = null;
    correctUdiseCodeController.clear();
    libraryDescriptionController.clear();
    dateController.clear();
    dateController2.clear();
    _multipleImage.clear();
    _imagePaths.clear();
    _multipleImage2.clear();
    _imagePaths2.clear();
    update();
  }

  Future<void> fetchData() async {
    isLoading = true;
    update();
    _issueTrackerList = await LocalDbController().fetchLocalIssueTrackerRecords();
    _libIssueList = await LocalDbController().fetchLocalLibIssueRecords();
    _furnitureIssueList = await LocalDbController().fetchLocalFurnitureIssue();
    _playgroundIssueList = await LocalDbController().fetchLocalPlaygroundIssue();
    _digiLabIssueList = await LocalDbController().fetchLocalDigiLabIssue();
    _alexaIssueList = await LocalDbController().fetchLocalAlexaIssue();

    // _libIssueList = await LocalDbController().fetchLocalLibIssue();
    // _playIssueList = await LocalDbController().fetchLocalPlayIssue();
    isLoading = false;
    update();
  }



}

