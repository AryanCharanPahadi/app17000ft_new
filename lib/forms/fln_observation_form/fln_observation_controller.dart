
import 'dart:convert';
import 'dart:io';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/forms/alfa_observation_form/alfa_obervation_modal.dart';
import 'package:app17000ft_new/forms/fln_observation_form/fln_observation_modal.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment_model.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment_sync.dart';
import 'package:app17000ft_new/helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../base_client/baseClient_controller.dart';
class FlnObservationController extends GetxController with BaseController{

  String? _tourValue;
  String? get tourValue => _tourValue;

  //school Value
  String? _schoolValue;
  String? get schoolValue => _schoolValue;

  bool isLoading = false;

  final TextEditingController remarksController = TextEditingController();
  final TextEditingController correctUdiseCodeController = TextEditingController();
  final TextEditingController noOfStaffTrainedController = TextEditingController();
  final TextEditingController moduleEnglishController = TextEditingController();
  final TextEditingController alfaNumercyController = TextEditingController();
  final TextEditingController noOfTeacherTrainedController = TextEditingController();


  // Map to store selected values for radio buttons
  final Map<String, String?> _selectedValues = {};
  String? getSelectedValue(String key) => _selectedValues[key];

  // Map to store error states for radio buttons
  final Map<String, bool> _radioFieldErrors = {};
  bool getRadioFieldError(String key) => _radioFieldErrors[key] ?? false;

  // Method to set the selected value and clear any previous error
  void setRadioValue(String key, String? value) {
    _selectedValues[key] = value;
    _radioFieldErrors[key] = false; // Clear error when a value is selected
    update(); // Update the UI
  }

  // Method to validate radio button selection
  bool validateRadioSelection(String key) {
    if (_selectedValues[key] == null) {
      _radioFieldErrors[key] = true;
      update(); // Update the UI
      return false;
    }
    _radioFieldErrors[key] = false;
    update(); // Update the UI
    return true;
  }



  //Focus nodes
  final FocusNode _tourIdFocusNode = FocusNode();
  FocusNode get  tourIdFocusNode => _tourIdFocusNode;
  final FocusNode _schoolFocusNode = FocusNode();
  FocusNode get  schoolFocusNode => _schoolFocusNode;

  List<FlnObservationModel> _flnObservationList =[];
  List<FlnObservationModel> get flnObservationList => _flnObservationList;

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


  final List<XFile> _multipleImage6 = [];
  List<XFile> get multipleImage6 => _multipleImage6;
  List<String> _imagePaths6 = [];
  List<String> get imagePaths6 => _imagePaths6;
  List<File> _imageFiles6 = [];
  List<File> get imageFiles6 => _imageFiles6;



  final List<XFile> _multipleImage7 = [];
  List<XFile> get multipleImage7 => _multipleImage7;
  List<String> _imagePaths7 = [];
  List<String> get imagePaths7 => _imagePaths7;
  List<File> _imageFiles7 = [];
  List<File> get imageFiles7 => _imageFiles7;

  final List<XFile> _multipleImage8 = [];
  List<XFile> get multipleImage8 => _multipleImage8;
  List<String> _imagePaths8 = [];
  List<String> get imagePaths8 => _imagePaths8;
  List<File> _imageFiles8 = [];
  List<File> get imageFiles8 => _imageFiles8;


  final List<XFile> _multipleImage9 = [];
  List<XFile> get multipleImage9 => _multipleImage9;
  List<String> _imagePaths9 = [];
  List<String> get imagePaths9 => _imagePaths9;
  List<File> _imageFiles9 = [];
  List<File> get imageFiles9 => _imageFiles9;

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

  // Convert a File to Base64 String
  Future<List<String>> convertImagesToBase64_6() async {
    List<String> base64Images6 = [];

    for (var image in _imageFiles6) { // _imageFiles is the list of File objects
      final bytes = await image.readAsBytes();
      base64Images6.add(base64Encode(bytes));
    }
    return base64Images6;
  }

  // Convert a File to Base64 String
  Future<List<String>> convertImagesToBase64_7() async {
    List<String> base64Images7 = [];

    for (var image in _imageFiles7) { // _imageFiles is the list of File objects
      final bytes = await image.readAsBytes();
      base64Images7.add(base64Encode(bytes));
    }
    return base64Images7;
  }

  // Convert a File to Base64 String
  Future<List<String>> convertImagesToBase64_8() async {
    List<String> base64Images8 = [];

    for (var image in _imageFiles8) { // _imageFiles is the list of File objects
      final bytes = await image.readAsBytes();
      base64Images8.add(base64Encode(bytes));
    }
    return base64Images8;
  }

  // Convert a File to Base64 String
  Future<List<String>> convertImagesToBase64_9() async {
    List<String> base64Images9 = [];

    for (var image in _imageFiles9) { // _imageFiles is the list of File objects
      final bytes = await image.readAsBytes();
      base64Images9.add(base64Encode(bytes));
    }
    return base64Images9;
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

  Future<String> takePhoto6(ImageSource source) async {
    final ImagePicker picker6 = ImagePicker();
    _multipleImage6.clear();  // Clear the existing images
    _imagePaths6 = [];
    _imageFiles6 = [];  // Clear the converted File objects

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
      final selectedImages6 = await picker6.pickMultiImage();
      if (selectedImages6 != null) {
        for (XFile xfile in selectedImages6) {
          File originalFile = File(xfile.path);
          File? processedFile = await processImage(originalFile);
          if (processedFile != null) {
            _multipleImage6.add(XFile(processedFile.path));
            _imagePaths6.add(processedFile.path);
            _imageFiles6.add(processedFile);
          }
        }
      }
    } else if (source == ImageSource.camera) {
      final pickedImage6 = await picker6.pickImage(source: source);
      if (pickedImage6 != null) {
        File originalFile = File(pickedImage6.path);
        File? processedFile = await processImage(originalFile);
        if (processedFile != null) {
          _multipleImage6.add(XFile(processedFile.path));
          _imagePaths6.add(processedFile.path);
          _imageFiles6.add(processedFile);
        }
      }
    }
    update();
    return _imagePaths6.toString();
  }

  Future<String> takePhoto7(ImageSource source) async {
    final ImagePicker picker7 = ImagePicker();
    _multipleImage7.clear();  // Clear the existing images
    _imagePaths7 = [];
    _imageFiles7 = [];  // Clear the converted File objects

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
      final selectedImages7 = await picker7.pickMultiImage();
      if (selectedImages7 != null) {
        for (XFile xfile in selectedImages7) {
          File originalFile = File(xfile.path);
          File? processedFile = await processImage(originalFile);
          if (processedFile != null) {
            _multipleImage7.add(XFile(processedFile.path));
            _imagePaths7.add(processedFile.path);
            _imageFiles7.add(processedFile);
          }
        }
      }
    } else if (source == ImageSource.camera) {
      final pickedImage7 = await picker7.pickImage(source: source);
      if (pickedImage7 != null) {
        File originalFile = File(pickedImage7.path);
        File? processedFile = await processImage(originalFile);
        if (processedFile != null) {
          _multipleImage7.add(XFile(processedFile.path));
          _imagePaths7.add(processedFile.path);
          _imageFiles7.add(processedFile);
        }
      }
    }
    update();
    return _imagePaths7.toString();
  }


  Future<String> takePhoto8(ImageSource source) async {
    final ImagePicker picker8 = ImagePicker();
    _multipleImage8.clear();  // Clear the existing images
    _imagePaths8 = [];
    _imageFiles8 = [];  // Clear the converted File objects

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
      final selectedImages8 = await picker8.pickMultiImage();
      if (selectedImages8 != null) {
        for (XFile xfile in selectedImages8) {
          File originalFile = File(xfile.path);
          File? processedFile = await processImage(originalFile);
          if (processedFile != null) {
            _multipleImage8.add(XFile(processedFile.path));
            _imagePaths8.add(processedFile.path);
            _imageFiles8.add(processedFile);
          }
        }
      }
    } else if (source == ImageSource.camera) {
      final pickedImage8 = await picker8.pickImage(source: source);
      if (pickedImage8 != null) {
        File originalFile = File(pickedImage8.path);
        File? processedFile = await processImage(originalFile);
        if (processedFile != null) {
          _multipleImage8.add(XFile(processedFile.path));
          _imagePaths8.add(processedFile.path);
          _imageFiles8.add(processedFile);
        }
      }
    }
    update();
    return _imagePaths8.toString();
  }


  Future<String> takePhoto9(ImageSource source) async {
    final ImagePicker picker9 = ImagePicker();
    _multipleImage9.clear();  // Clear the existing images
    _imagePaths9 = [];
    _imageFiles9 = [];  // Clear the converted File objects

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
      final selectedImages9 = await picker9.pickMultiImage();
      if (selectedImages9 != null) {
        for (XFile xfile in selectedImages9) {
          File originalFile = File(xfile.path);
          File? processedFile = await processImage(originalFile);
          if (processedFile != null) {
            _multipleImage9.add(XFile(processedFile.path));
            _imagePaths9.add(processedFile.path);
            _imageFiles9.add(processedFile);
          }
        }
      }
    } else if (source == ImageSource.camera) {
      final pickedImage9 = await picker9.pickImage(source: source);
      if (pickedImage9 != null) {
        File originalFile = File(pickedImage9.path);
        File? processedFile = await processImage(originalFile);
        if (processedFile != null) {
          _multipleImage9.add(XFile(processedFile.path));
          _imagePaths9.add(processedFile.path);
          _imageFiles9.add(processedFile);
        }
      }
    }
    update();
    return _imagePaths9.toString();
  }


  setSchool(value)
  {
    _schoolValue = value;
    // update();
  }

  setTour(value){
    _tourValue = value;
    // update();

  }



  Widget bottomSheet(BuildContext context) {
    String? imagePicked;
    PickedFile? imageFile;
    final ImagePicker picker = ImagePicker();
    XFile? image;
    return Container(
      color: AppColors.primary,
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Select Image",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // ignore: deprecated_member_use
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  imagePicked = await takePhoto(ImageSource.camera);

                  // uploadFile(userdata.read('customerID'));
                  Get.back();
                  //  update();
                },
                child: const Text(
                  'Camera',
                  style: TextStyle(
                      fontSize: 20.0, color: AppColors.primary),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  imagePicked = await takePhoto(
                    ImageSource.gallery,
                  );

                  Get.back();
                  //  update();
                },
                child: const Text(
                  'Gallery',
                  style: TextStyle(
                      fontSize: 20.0, color: AppColors.primary),
                ),
              ),
            ],
          )
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


  Widget bottomSheet6(BuildContext context) {
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
                  await takePhoto6(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto6(ImageSource.gallery);
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


  Widget bottomSheet7(BuildContext context) {
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
                  await takePhoto7(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto7(ImageSource.gallery);
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


  Widget bottomSheet8(BuildContext context) {
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
                  await takePhoto8(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto8(ImageSource.gallery);
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

  Widget bottomSheet9(BuildContext context) {
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
                  await takePhoto9(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto9(ImageSource.gallery);
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
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain,
              ),
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


  void showImagePreview6(String imagePath6, BuildContext context) {
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
              child: Image.file(File(imagePath6), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }

  void showImagePreview7(String imagePath7, BuildContext context) {
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
              child: Image.file(File(imagePath7), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }


  void showImagePreview8(String imagePath8, BuildContext context) {
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
              child: Image.file(File(imagePath8), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }


  void showImagePreview9(String imagePath9, BuildContext context) {
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
              child: Image.file(File(imagePath9), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }

  //Clear fields
  void clearFields() {

    update();
  }

  fetchData() async {
    isLoading = true;

    _flnObservationList = [];
    _flnObservationList = await LocalDbController().fetchLocalFlnObservationModel();

    update();
  }

//

//Update the UI


}