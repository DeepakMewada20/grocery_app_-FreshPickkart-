import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FreshPointsHistoryScreen extends StatefulWidget {
  const FreshPointsHistoryScreen({super.key});

  @override
  State<FreshPointsHistoryScreen> createState() =>
      _FreshPointsHistoryScreenState();
}

class _FreshPointsHistoryScreenState extends State<FreshPointsHistoryScreen> {
  final _client = ServerpodClient().client;
  final _auth = AuthController.instance;

  final _transactions = <FreshPointsTransaction>[];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _nextPageToken;
  bool _hasMore = true;
  int _balance = 0;
  int _totalEarned = 0;
  int _totalRedeemed = 0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions({bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMore || !_hasMore) return;
      setState(() => _isLoadingMore = true);
    } else {
      setState(() => _isLoading = true);
    }

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final result = await _client.freshPoints.getMyTransactions(
        userId,
        limit: 20,
        pageToken: loadMore ? _nextPageToken : null,
      );

      _balance = result['balance'] as int? ?? 0;
      _totalEarned = result['totalEarned'] as int? ?? 0;
      _totalRedeemed = result['totalRedeemed'] as int? ?? 0;
      final txnList = (result['transactions'] as List<dynamic>?)
              ?.cast<Map<String, dynamic>>()
              .map((e) => FreshPointsTransaction.fromJson(e))
              .toList() ??
          [];

      if (loadMore) {
        _transactions.addAll(txnList);
      } else {
        _transactions.assignAll(txnList);
      }
      _nextPageToken = result['nextPageToken'] as String?;
      _hasMore = _nextPageToken != null && txnList.length >= 20;
    } catch (_) {
    } finally {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FreshPoints'),
        backgroundColor: cs.surface,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _loadTransactions(),
              child: ListView(
                padding: EdgeInsets.all(16.w),
                children: [
                  _buildSummaryCard(cs),
                  SizedBox(height: 16.h),
                  ...List.generate(_transactions.length, (i) {
                    final txn = _transactions[i];
                    return _buildTransactionRow(context, cs, txn);
                  }),
                  if (_isLoadingMore)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (!_isLoadingMore && _hasMore)
                    TextButton(
                      onPressed: () => _loadTransactions(loadMore: true),
                      child: const Text('Load More'),
                    ),
                  if (_transactions.isEmpty && !_isLoading)
                    Padding(
                      padding: EdgeInsets.all(32.h),
                      child: Center(
                        child: Text(
                          'No transactions yet',
                          style: TextStyle(color: cs.onSurfaceVariant),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCard(ColorScheme cs) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cs.primary, cs.primary.withValues(alpha: 0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(Icons.monetization_on_outlined, color: Colors.white, size: 22.w),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text('BALANCE',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 10.sp, letterSpacing: 1.5)),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              '$_balance',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Available Points',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13.sp,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat('Earned', _totalEarned),
                  Container(
                    width: 1,
                    height: 24.h,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  _buildStat('Redeemed', _totalRedeemed),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, int value) {
    return Column(
      children: [
        Text(
          '$value',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTransactionRow(
    BuildContext context,
    ColorScheme cs,
    FreshPointsTransaction txn,
  ) {
    final isPositive = txn.points > 0;
    final icon = isPositive ? Icons.add_circle_outline : Icons.remove_circle_outline;
    final color = isPositive ? cs.primary : cs.error;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    txn.description ?? txn.transactionType,
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 14.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    _formatDate(txn.createdAt),
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${isPositive ? '+' : ''}${txn.points}',
              style: TextStyle(
                color: color,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final utc = DateTime.utc(dt.year, dt.month, dt.day, dt.hour, dt.minute);
    final local = utc.toLocal();
    return '${local.day}/${local.month}/${local.year} ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}
