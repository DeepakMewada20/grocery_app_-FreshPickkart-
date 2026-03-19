import 'package:flutter/material.dart';

class ImagePickerButton extends StatelessWidget {
  const ImagePickerButton({
    super.key,
    required this.isUploading,
    required this.onPressed,
    this.label = 'Choose Image',
  });

  final bool isUploading;
  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.tonal(
        onPressed: isUploading ? null : onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isUploading) ...[
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 8),
              const Text('Uploading...'),
            ] else ...[
              const Icon(Icons.upload_file, size: 20),
              const SizedBox(width: 8),
              Text(label),
            ],
          ],
        ),
      ),
    );
  }
}
