import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

class BogoSelectorWidget extends StatelessWidget {
  final List<Product> selectedProducts;
  final Set<String> unresolvedIds;
  final bool canBrowse;
  final Future<void> Function() onBrowsePressed;
  final ValueChanged<String> onRemove;
  final Map<String, String> freeProductQuantities;

  const BogoSelectorWidget({
    super.key,
    required this.selectedProducts,
    required this.unresolvedIds,
    required this.canBrowse,
    required this.onBrowsePressed,
    required this.onRemove,
    required this.freeProductQuantities,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 360;
            final title = Expanded(
              child: Text(
                'Free Products (Pick one or more)',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AdminTextStyles.cardTitle(context),
              ),
            );
            final button = FilledButton.tonalIcon(
              onPressed: canBrowse ? onBrowsePressed : null,
              icon: Icon(Icons.grid_view_rounded, size: 18.r),
              label: Text(
                selectedProducts.isEmpty ? 'Browse Products' : 'Edit',
                overflow: TextOverflow.ellipsis,
              ),
            );
            if (isCompact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Free Products (Pick one or more)',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AdminTextStyles.cardTitle(context),
                  ),
                  SizedBox(height: 8.h),
                  button,
                ],
              );
            }
            return Row(
              children: [
                title,
                SizedBox(width: 8.w),
                button,
              ],
            );
          },
        ),
        SizedBox(height: 8.h),
        if (!canBrowse)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Text(
              'Select the main product category first.',
              style: AdminTextStyles.body(context),
            ),
          )
        else if (selectedProducts.isEmpty && unresolvedIds.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              'No free products selected yet.',
              style: AdminTextStyles.body(context),
            ),
          )
        else
          Column(
            children: [
              ...selectedProducts.map((product) {
                final productId = product.productId;
                final normalizedConfiguredQuantity = productId == null
                    ? null
                    : freeProductQuantities[productId]?.trim();
                final freeQuantity = productId == null
                    ? product.quantity
                    : (normalizedConfiguredQuantity != null &&
                          normalizedConfiguredQuantity.isNotEmpty)
                    ? normalizedConfiguredQuantity
                    : product.quantity;
                return Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Container(
                              width: 52.r,
                              height: 52.r,
                              color: Colors.grey.shade100,
                              child: product.imageUrl.isEmpty
                                  ? const Icon(Icons.image_outlined)
                                  : Image.network(
                                      product.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.broken_image_outlined,
                                            );
                                          },
                                    ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.productName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AdminTextStyles.cardTitle(context),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  '${product.category} • Pack: ${product.quantity}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: productId == null
                                ? null
                                : () => onRemove(productId),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.green.shade100),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.scale_rounded,
                              size: 18.r,
                              color: Colors.green.shade700,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                'Free quantity: $freeQuantity',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AdminTextStyles.caption(context)
                                    .copyWith(
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              if (unresolvedIds.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: unresolvedIds
                      .map(
                        (id) => Chip(
                          label: Text('Unresolved: $id'),
                          onDeleted: () => onRemove(id),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
      ],
    );
  }
}
