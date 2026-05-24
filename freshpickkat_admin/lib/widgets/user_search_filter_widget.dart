import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

enum _UserSortOption {
  name('Name'),
  orders('Most Orders'),
  amount('Highest Amount Spent'),
  recent('Recent Orders');

  final String label;
  const _UserSortOption(this.label);
}

/// Reusable widget for searching and filtering users
/// Can be used in both view-only mode (Active Users screen) and selection mode (Broadcasts screen)
class UserSearchFilterWidget extends StatefulWidget {
  final List<ActiveUserStatistics> allUsers;
  final bool enableSelection;
  final ValueChanged<List<ActiveUserStatistics>>? onSelectionChanged;
  final bool isMobileLayout;

  const UserSearchFilterWidget({
    super.key,
    required this.allUsers,
    this.enableSelection = false,
    this.onSelectionChanged,
    this.isMobileLayout = false,
  });

  @override
  State<UserSearchFilterWidget> createState() => UserSearchFilterWidgetState();
}

class UserSearchFilterWidgetState extends State<UserSearchFilterWidget> {
  late TextEditingController _searchController;
  _UserSortOption _sortOption = _UserSortOption.name;
  final Set<String> _selectedUserIds = {};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filter and sort users based on search query and sort option
  List<ActiveUserStatistics> _getFilteredAndSortedUsers() {
    List<ActiveUserStatistics> filtered = widget.allUsers;

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((user) {
        return (user.name?.toLowerCase().contains(query) ?? false) ||
            user.phoneNumber.toLowerCase().contains(query);
      }).toList();
    }

    // Sort
    filtered.sort((a, b) {
      switch (_sortOption) {
        case _UserSortOption.orders:
          return b.totalOrdersCount.compareTo(a.totalOrdersCount);
        case _UserSortOption.amount:
          return b.totalSpent.compareTo(a.totalSpent);
        case _UserSortOption.recent:
          final aDate = a.lastOrderDate ?? DateTime(1970);
          final bDate = b.lastOrderDate ?? DateTime(1970);
          return bDate.compareTo(aDate);
        case _UserSortOption.name:
          return (a.name ?? '').compareTo(b.name ?? '');
      }
    });

    return filtered;
  }

  /// Toggle user selection
  void _toggleUserSelection(String userId) {
    setState(() {
      if (_selectedUserIds.contains(userId)) {
        _selectedUserIds.remove(userId);
      } else {
        _selectedUserIds.add(userId);
      }
      _notifySelectionChanged();
    });
  }

  /// Notify parent about selection changes
  void _notifySelectionChanged() {
    if (widget.enableSelection && widget.onSelectionChanged != null) {
      final selectedUsers = widget.allUsers
          .where((user) => _selectedUserIds.contains(user.userId))
          .toList();
      widget.onSelectionChanged!(selectedUsers);
    }
  }

  /// Select all filtered users
  void _selectAll() {
    setState(() {
      final filteredUsers = _getFilteredAndSortedUsers();
      for (final user in filteredUsers) {
        _selectedUserIds.add(user.userId);
      }
      _notifySelectionChanged();
    });
  }

  /// Clear all selections
  void _clearSelection() {
    setState(() {
      _selectedUserIds.clear();
      _notifySelectionChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _getFilteredAndSortedUsers();
    final hasResults = filteredUsers.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar
        TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search by name or mobile number',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
        ),
        SizedBox(height: 12.h),

        // Filter Options
        _buildFilterRow(context),
        SizedBox(height: 16.h),

        // Selection Controls (only if selection enabled)
        if (widget.enableSelection) ...[
          _buildSelectionControls(context),
          SizedBox(height: 12.h),
        ],

        // Users List/Table
        if (!hasResults)
          _buildEmptyState(context)
        else
          Expanded(child: _buildUsersList(context, filteredUsers)),
      ],
    );
  }

  /// Build filter row with sort options as horizontal scrollable chips
  Widget _buildFilterRow(BuildContext context) {
    return SizedBox(
      height: 34.h.clamp(34.0, 42.0),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _UserSortOption.values.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final option = _UserSortOption.values[index];
          final isSelected = _sortOption == option;
          return Theme(
            data: Theme.of(context).copyWith(
              chipTheme: Theme.of(context).chipTheme.copyWith(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                side: BorderSide(
                  color: isSelected
                      ? AdminAppTheme.getSuccessColor(context)
                      : AdminAppTheme.getBorderColor(context),
                ),
                backgroundColor: AdminThemeTokens.white,
                selectedColor: AdminAppTheme.getSuccessColor(
                  context,
                ).withValues(alpha: 0.12),
                labelStyle: TextStyle(
                  fontSize: 12.sp.clamp(10.0, 13.0),
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AdminAppTheme.getSuccessColor(context)
                      : AdminAppTheme.getTextPrimaryColor(context),
                ),
                padding: EdgeInsets.symmetric(horizontal: 4.w),
              ),
            ),
            child: ChoiceChip(
              label: Text(option.label),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _sortOption = option;
                });
              },
            ),
          );
        },
      ),
    );
  }

  /// Build selection controls
  Widget _buildSelectionControls(BuildContext context) {
    final filtered = _getFilteredAndSortedUsers();
    final hasFilteredUsers = filtered.isNotEmpty;
    final allSelected = hasFilteredUsers &&
        _selectedUserIds.length == filtered.length;
    return Row(
      children: [
        Text(
          'Selected: ${_selectedUserIds.length}',
          style: AdminTextStyles.body(
            context,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        _CompactActionChip(
          label: 'Select All',
          onTap: allSelected ? _clearSelection : (hasFilteredUsers ? _selectAll : null),
          isSelected: allSelected,
        ),
        SizedBox(width: 8.w),
        _CompactActionChip(
          label: 'Clear',
          onTap: _selectedUserIds.isNotEmpty ? _clearSelection : null,
        ),
      ],
    );
  }

  /// Get selected users list
  List<ActiveUserStatistics> getSelectedUsers() {
    return widget.allUsers
        .where((user) => _selectedUserIds.contains(user.userId))
        .toList();
  }

  /// Build empty state
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off_outlined,
            size: 48.sp,
            color: AdminAppTheme.getTextSecondaryColor(context),
          ),
          SizedBox(height: 12.h),
          Text(
            _searchQuery.isEmpty
                ? 'No users available'
                : 'No users found for "$_searchQuery"',
            style: AdminTextStyles.body(
              context,
            ).copyWith(color: AdminAppTheme.getTextSecondaryColor(context)),
          ),
        ],
      ),
    );
  }

  /// Build users list/table
  Widget _buildUsersList(
    BuildContext context,
    List<ActiveUserStatistics> users,
  ) {
    if (widget.isMobileLayout) {
      return _buildMobileList(context, users);
    } else {
      return _buildDesktopTable(context, users);
    }
  }

  /// Mobile list view
  Widget _buildMobileList(
    BuildContext context,
    List<ActiveUserStatistics> users,
  ) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final isSelected = _selectedUserIds.contains(user.userId);

        return Card(
          margin: EdgeInsets.only(bottom: 8.h),
          child: ListTile(
            leading: widget.enableSelection
                ? Checkbox(
                    value: isSelected,
                    onChanged: (_) => _toggleUserSelection(user.userId),
                  )
                : null,
            title: Text(
              user.name ?? 'Unknown',
              style: AdminTextStyles.cardTitle(context),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.h),
                Text(user.phoneNumber, style: AdminTextStyles.caption(context)),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Orders: ${user.totalOrdersCount}',
                      style: AdminTextStyles.caption(context),
                    ),
                    Text(
                      '₹${user.totalSpent.toStringAsFixed(2)}',
                      style: AdminTextStyles.caption(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
            onTap: widget.enableSelection
                ? () => _toggleUserSelection(user.userId)
                : null,
            selected: isSelected,
          ),
        );
      },
    );
  }

  /// Desktop table view
  Widget _buildDesktopTable(
    BuildContext context,
    List<ActiveUserStatistics> users,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateColor.resolveWith(
            (_) => AdminAppTheme.getSubtleSurfaceColor(context),
          ),
          columns: [
            DataColumn(
              label: Text('Name', style: AdminTextStyles.cardTitle(context)),
            ),
            DataColumn(
              label: Text(
                'Phone Number',
                style: AdminTextStyles.cardTitle(context),
              ),
            ),
            DataColumn(
              label: Text(
                'Total Orders',
                style: AdminTextStyles.cardTitle(context),
              ),
            ),
            DataColumn(
              label: Text(
                'Total Spent',
                style: AdminTextStyles.cardTitle(context),
              ),
            ),
            DataColumn(
              label: Text(
                'Last Order',
                style: AdminTextStyles.cardTitle(context),
              ),
            ),
          ],
          rows: users.map((user) {
            final isSelected = _selectedUserIds.contains(user.userId);
            return DataRow(
              selected: isSelected,
              onSelectChanged: widget.enableSelection
                  ? (_) => _toggleUserSelection(user.userId)
                  : null,
              cells: [
                DataCell(
                  Text(user.name ?? '-', style: AdminTextStyles.body(context)),
                ),
                DataCell(
                  Text(user.phoneNumber, style: AdminTextStyles.body(context)),
                ),
                DataCell(
                  Text(
                    '${user.totalOrdersCount}',
                    style: AdminTextStyles.body(context),
                  ),
                ),
                DataCell(
                  Text(
                    '₹${user.totalSpent.toStringAsFixed(2)}',
                    style: AdminTextStyles.body(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                DataCell(
                  Text(
                    user.lastOrderDate == null
                        ? '-'
                        : '${user.lastOrderDate?.day}/${user.lastOrderDate?.month}/${user.lastOrderDate?.year}',
                    style: AdminTextStyles.body(context),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Compact rectangular action chip matching filter chip style
class _CompactActionChip extends StatelessWidget {
  const _CompactActionChip({
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    final useActive = isSelected && !isDisabled;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: useActive
                  ? AdminAppTheme.getSuccessColor(context)
                  : AdminAppTheme.getBorderColor(context),
            ),
            borderRadius: BorderRadius.circular(8.r),
            color: useActive
                ? AdminAppTheme.getSuccessColor(context).withValues(alpha: 0.1)
                : Colors.transparent,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp.clamp(10.0, 13.0),
              fontWeight: FontWeight.w600,
              color: useActive
                  ? AdminAppTheme.getSuccessColor(context)
                  : AdminAppTheme.getTextSecondaryColor(context),
            ),
          ),
        ),
      ),
    );
  }
}
