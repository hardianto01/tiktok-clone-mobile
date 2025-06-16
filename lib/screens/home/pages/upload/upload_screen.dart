// lib/screens/home/pages/upload/upload_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:typed_data';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/video_provider.dart';
import '../../../../services/video_service.dart';
import '../../../../services/api_service.dart';
import '../../../../constants/app_icons.dart';
import 'package:image_picker/image_picker.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hashtagsController = TextEditingController();

  // For mobile platforms
  File? _selectedVideo;
  File? _selectedThumbnail;
  
  // For web platform
  Uint8List? _selectedVideoBytes;
  String? _selectedVideoName;
  String? _selectedFileName;
  String? _selectedFileType;

  String? _selectedCategory = '1';
  bool _isUploading = false;
  bool _isPublic = true;

  final List<Map<String, dynamic>> _categories = [
    {'id': '1', 'name': 'Menyanyi & Menari'},
    {'id': '2', 'name': 'Komedi'},
    {'id': '3', 'name': 'Olahraga'},
    {'id': '4', 'name': 'Anime & Komik'},
    {'id': '5', 'name': 'Hubungan'},
    {'id': '6', 'name': 'Pertunjukan'},
    {'id': '7', 'name': 'Lipsync'},
    {'id': '8', 'name': 'Kehidupan Sehari-hari'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Upload Content', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_selectedVideo != null || _selectedVideoBytes != null)
            TextButton(
              onPressed: _isUploading ? null : _handleUpload,
              child: _isUploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFileSelector(),
            if (_selectedVideo != null || _selectedVideoBytes != null) ...[
              const SizedBox(height: 24),
              _buildFormSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFileSelector() {
    if (_selectedVideo != null || _selectedVideoBytes != null) {
      return _buildSelectedFilePreview();
    }

    return Column(
      children: [
        const SizedBox(height: 40),
        const Icon(
          Icons.cloud_upload_outlined,
          size: 80,
          color: Colors.grey,
        ),
        const SizedBox(height: 24),
        const Text(
          'Upload your video or photo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Share your creativity with the world',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: _buildUploadButton(
                icon: Icons.videocam,
                label: 'Video',
                subtitle: 'MP4, MOV (Max 50MB)',
                onTap: _selectVideo,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildUploadButton(
                icon: Icons.image,
                label: 'Photo',
                subtitle: 'JPG, PNG (Max 10MB)',
                onTap: _selectImage,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: _buildUploadButton(
            icon: Icons.folder_open,
            label: 'Browse Files',
            subtitle: 'Choose from device storage',
            onTap: _selectFromFiles,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[700]!),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedFilePreview() {
    final isVideo = _isVideoFile();
    
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isVideo ? Icons.play_circle_fill : Icons.image,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                Text(
                  isVideo ? 'Video Selected' : 'Image Selected',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedFileName ?? 'Selected file',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: _clearSelection,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: GestureDetector(
              onTap: _selectDifferentFile,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Change',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleField(),
        const SizedBox(height: 20),
        _buildDescriptionField(),
        const SizedBox(height: 20),
        _buildCategorySelector(),
        const SizedBox(height: 20),
        _buildHashtagsField(),
        if (_isVideoFile()) ...[
          const SizedBox(height: 20),
          _buildThumbnailSelector(),
        ],
        const SizedBox(height: 20),
        _buildPrivacySettings(),
        const SizedBox(height: 32),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Title *',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _titleController,
          style: const TextStyle(color: Colors.white),
          maxLength: 100,
          decoration: InputDecoration(
            hintText: 'Add a catchy title...',
            hintStyle: TextStyle(color: Colors.grey[500]),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            counterStyle: TextStyle(color: Colors.grey[500]),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          style: const TextStyle(color: Colors.white),
          maxLines: 4,
          maxLength: 500,
          decoration: InputDecoration(
            hintText: 'Tell viewers about your content...',
            hintStyle: TextStyle(color: Colors.grey[500]),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            counterStyle: TextStyle(color: Colors.grey[500]),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Consumer<VideoProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category *',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  hint: Text(
                    'Select a category',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  dropdownColor: Colors.grey[800],
                  style: const TextStyle(color: Colors.white),
                  items: _categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category['id'],
                      child: Text(category['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHashtagsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hashtags',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _hashtagsController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: '#trending #viral #fun (separate with spaces)',
            hintStyle: TextStyle(color: Colors.grey[500]),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnailSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thumbnail (Optional)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectThumbnail,
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[700]!),
            ),
            child: _selectedThumbnail != null
                ? Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(_selectedThumbnail!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: _clearThumbnail,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate, color: Colors.grey[600]),
                      const SizedBox(height: 8),
                      Text(
                        'Add Thumbnail',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacySettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Privacy',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Public', style: TextStyle(color: Colors.white)),
            subtitle: Text(
              _isPublic 
                  ? 'Everyone can see this content'
                  : 'Only you can see this content',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
            value: _isPublic,
            onChanged: (value) {
              setState(() {
                _isPublic = value;
              });
            },
            activeColor: Colors.red,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _canUpload() && !_isUploading ? _handleUpload : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          disabledBackgroundColor: Colors.grey[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isUploading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Upload Content',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  // Helper methods
  Future<void> _selectVideo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
        withData: kIsWeb,
      );

      if (result != null) {
        final file = result.files.single;

        if (file.size > 50 * 1024 * 1024) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File too large. Maximum size is 50MB.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        if (kIsWeb) {
          setState(() {
            _selectedVideoBytes = file.bytes!;
            _selectedVideoName = file.name;
            _selectedFileName = file.name;
            _selectedFileType = 'video';
          });
        } else {
          setState(() {
            _selectedVideo = File(file.path!);
            _selectedFileName = file.name;
            _selectedFileType = 'video';
          });
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Video selected: ${file.name}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting video: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: kIsWeb,
      );

      if (result != null) {
        final file = result.files.single;

        if (file.size > 10 * 1024 * 1024) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File too large. Maximum size is 10MB.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        if (kIsWeb) {
          setState(() {
            _selectedVideoBytes = file.bytes!;
            _selectedVideoName = file.name;
            _selectedFileName = file.name;
            _selectedFileType = 'image';
          });
        } else {
          setState(() {
            _selectedVideo = File(file.path!);
            _selectedFileName = file.name;
            _selectedFileType = 'image';
          });
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image selected: ${file.name}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectFromFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: false,
        withData: kIsWeb,
      );

      if (result != null) {
        final file = result.files.single;
        final isVideo = _isVideoExtension(file.extension);
        final maxSize = isVideo ? 50 * 1024 * 1024 : 10 * 1024 * 1024;

        if (file.size > maxSize) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File too large. Maximum size is ${isVideo ? '50MB' : '10MB'}.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        if (kIsWeb) {
          setState(() {
            _selectedVideoBytes = file.bytes!;
            _selectedVideoName = file.name;
            _selectedFileName = file.name;
            _selectedFileType = isVideo ? 'video' : 'image';
          });
        } else {
          setState(() {
            _selectedVideo = File(file.path!);
            _selectedFileName = file.name;
            _selectedFileType = isVideo ? 'video' : 'image';
          });
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${isVideo ? 'Video' : 'Image'} selected: ${file.name}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectThumbnail() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && !kIsWeb) {
        setState(() {
          _selectedThumbnail = File(result.files.single.path!);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting thumbnail: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedVideo = null;
      _selectedVideoBytes = null;
      _selectedVideoName = null;
      _selectedFileName = null;
      _selectedFileType = null;
      _selectedThumbnail = null;
      _titleController.clear();
      _descriptionController.clear();
      _hashtagsController.clear();
      _selectedCategory = '1';
    });
  }

  void _clearThumbnail() {
    setState(() {
      _selectedThumbnail = null;
    });
  }

  void _selectDifferentFile() {
    if (_isVideoFile()) {
      _selectVideo();
    } else {
      _selectImage();
    }
  }

  bool _isVideoFile() {
    if (_selectedFileType != null) {
      return _selectedFileType == 'video';
    }
    if (_selectedFileName != null) {
      return _isVideoExtension(_selectedFileName!.split('.').last);
    }
    return false;
  }

  bool _isVideoExtension(String? extension) {
    if (extension == null) return false;
    final videoExtensions = ['mp4', 'mov', 'avi', 'mkv', 'webm', 'm4v', '3gp'];
    return videoExtensions.contains(extension.toLowerCase());
  }

  bool _canUpload() {
    return (_selectedVideo != null || _selectedVideoBytes != null) &&
           _titleController.text.trim().isNotEmpty &&
           _selectedCategory != null;
  }

  Future<void> _handleUpload() async {
    if (!_canUpload()) {
      _showErrorSnackBar('Please fill in all required fields');
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAuthenticated) {
      _showErrorSnackBar('Please login to upload content');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Prepare hashtags
      final hashtags = _hashtagsController.text
          .split(' ')
          .where((tag) => tag.trim().isNotEmpty)
          .map((tag) => tag.startsWith('#') ? tag.substring(1) : tag)
          .toList();

      // Upload content
      Map<String, dynamic>? response;
      
      if (kIsWeb) {
        // For web, simulate upload for now
        await Future.delayed(const Duration(seconds: 2));
        response = {
          'message': 'Content uploaded successfully',
          'video': {
            'id': DateTime.now().millisecondsSinceEpoch,
            'title': _titleController.text.trim(),
            'description': _descriptionController.text.trim(),
          }
        };
      } else {
        // For mobile platforms, use actual API
        response = await ApiService.uploadVideo(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty 
              ? null 
              : _descriptionController.text.trim(),
          categoryId: int.parse(_selectedCategory!),
          videoPath: _selectedVideo!.path,
          thumbnailPath: _selectedThumbnail?.path,
          hashtags: hashtags.isEmpty ? null : hashtags,
        );
      }

      if (response != null && response['message'] != null) {
        // Refresh video list
        if (mounted) {
          final videoProvider = Provider.of<VideoProvider>(context, listen: false);
          videoProvider.refreshVideos();

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message']),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );

          // Navigate back to home
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/home',
            (route) => false,
          );
        }
      } else {
        _showErrorSnackBar('Upload failed. Please try again.');
      }
    } catch (e) {
      _showErrorSnackBar('Upload failed: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _hashtagsController.dispose();
    super.dispose();
  }
}