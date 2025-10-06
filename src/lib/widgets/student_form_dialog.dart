import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';
import '../models/student.dart';
import '../services/student_provider.dart';
import '../services/file_storage_service.dart';
import '../utils/validators.dart';
import '../constants/app_constants.dart';

class StudentFormDialog extends StatefulWidget {
  final Student? student; // If null, create mode; if not null, edit mode

  const StudentFormDialog({super.key, this.student});

  @override
  State<StudentFormDialog> createState() => _StudentFormDialogState();
}

class _StudentFormDialogState extends State<StudentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  File? _photoFile;
  File? _videoFile;
  String? _existingPhotoPath;
  String? _existingVideoPath;
  bool _isLoading = false;

  bool get isEditMode => widget.student != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _nameController.text = widget.student!.name;
      _emailController.text = widget.student!.email;
      _phoneController.text = widget.student!.phone;
      _existingPhotoPath = widget.student!.photoPath;
      _existingVideoPath = widget.student!.videoPath;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: AppConstants.allowedImageExtensions,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileSize = await file.length();

        // Check file size
        final sizeError = Validators.validateFileSize(
          fileSize,
          AppConstants.maxPhotoSizeBytes,
          'Photo',
        );
        if (sizeError != null) {
          Fluttertoast.showToast(msg: sizeError, backgroundColor: Colors.red);
          return;
        }

        setState(() {
          _photoFile = file;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to pick photo: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _pickVideo() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: AppConstants.allowedVideoExtensions,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);

        // Check video duration
        final controller = VideoPlayerController.file(file);
        await controller.initialize();
        final duration = controller.value.duration.inSeconds;
        controller.dispose();

        final durationError = Validators.validateVideoDuration(
          duration,
          AppConstants.maxVideoDurationSeconds,
        );
        if (durationError != null) {
          if (mounted) {
            Fluttertoast.showToast(
              msg: durationError,
              backgroundColor: Colors.red,
            );
          }
          return;
        }

        setState(() {
          _videoFile = file;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to pick video: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final provider = context.read<StudentProvider>();
      final fileStorage = FileStorageService.instance;

      String? photoPath = _existingPhotoPath;
      String? videoPath = _existingVideoPath;

      if (isEditMode) {
        // EDIT MODE
        // Save new photo if selected
        if (_photoFile != null) {
          photoPath = await fileStorage.savePhoto(
            _photoFile!,
            widget.student!.id,
          );
        }

        // Save new video if selected
        if (_videoFile != null) {
          videoPath = await fileStorage.saveVideo(
            _videoFile!,
            widget.student!.id,
          );
        }

        await provider.updateStudent(
          id: widget.student!.id,
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: Validators.formatPhoneNumber(_phoneController.text.trim()),
          photoPath: photoPath,
          videoPath: videoPath,
        );

        Fluttertoast.showToast(msg: 'Student updated successfully');
      } else {
        // CREATE MODE
        // For create, we need to generate ID first, but that happens in repository
        // We'll save files after student creation
        final student = await provider.createStudent(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: Validators.formatPhoneNumber(_phoneController.text.trim()),
        );

        // Now save files with the generated student ID
        if (_photoFile != null) {
          photoPath = await fileStorage.savePhoto(_photoFile!, student.id);
        }

        if (_videoFile != null) {
          videoPath = await fileStorage.saveVideo(_videoFile!, student.id);
        }

        // Update student with file paths if any files were uploaded
        if (photoPath != null || videoPath != null) {
          await provider.updateStudent(
            id: student.id,
            photoPath: photoPath,
            videoPath: videoPath,
          );
        }

        Fluttertoast.showToast(msg: 'Student created successfully');
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      String errorMessage = 'Save failed';
      if (e.toString().contains('Email already exists')) {
        errorMessage = 'This email is already registered';
      } else if (e.toString().contains('Phone number already exists')) {
        errorMessage = 'This phone number is already registered';
      } else if (e.toString().contains('Student not found')) {
        errorMessage = 'Student not found';
      } else {
        errorMessage =
            'Save failed: ${e.toString().replaceAll('Exception: ', '')}';
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    isEditMode ? 'Edit Student' : 'Add New Student',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isEditMode)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            'ID: ${widget.student!.id}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name *',
                          border: OutlineInputBorder(),
                        ),
                        validator: Validators.validateName,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email *',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone *',
                          hintText: '+91 XXXXXXXXXX',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: Validators.validatePhone,
                      ),
                      const SizedBox(height: 24),

                      // Photo Picker
                      const Text(
                        'Photo (optional)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: _pickPhoto,
                            icon: const Icon(Icons.image),
                            label: const Text('Choose Photo'),
                          ),
                          const SizedBox(width: 16),
                          if (_photoFile != null)
                            Text(_photoFile!.path.split('/').last)
                          else if (_existingPhotoPath != null)
                            const Text('Photo already uploaded'),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Video Picker
                      const Text(
                        'Video (optional, max 10 minutes)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: _pickVideo,
                            icon: const Icon(Icons.videocam),
                            label: const Text('Choose Video'),
                          ),
                          const SizedBox(width: 16),
                          if (_videoFile != null)
                            Expanded(
                              child: Text(
                                _videoFile!.path.split('/').last,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          else if (_existingVideoPath != null)
                            const Text('Video already uploaded'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveStudent,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isEditMode ? 'Update' : 'Create'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
