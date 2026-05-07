import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isUploading) ...[
              SizedBox(
                width: 18.r,
                height: 18.r,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 8.w),
              const Flexible(
                child: Text('Uploading...', overflow: TextOverflow.ellipsis),
              ),
            ] else ...[
              Icon(Icons.upload_file, size: 20.sp.clamp(18.0, 22.0)),
              SizedBox(width: 8.w),
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ],
          ],
        ),
      ),
    );
  }
}
