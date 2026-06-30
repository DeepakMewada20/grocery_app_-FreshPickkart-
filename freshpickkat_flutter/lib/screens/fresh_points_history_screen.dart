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
  final _expandedIds = <String>{};
  bool _isLoading = true;
  int _balance = 0;
  int _totalEarned = 0;
  int _totalRedeemed = 0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions({bool loadMore = false}) async {
    if (loadMore) return;
    setState(() => _isLoading = true);

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final balance = await _client.freshPoints.getMyBalance(userId);

      _balance = balance.balance;
      _totalEarned = balance.totalEarned;
      _totalRedeemed = balance.totalRedeemed;
      _transactions.assignAll(balance.transactions);
    } catch (e) {
      debugPrint('FreshPoints history error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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

  bool _isEarnType(String type) {
    return type == 'EARNED' || type == 'REFERRAL' || type == 'ADMIN_ADD' || type == 'REFUND_RESTORE';
  }

  String _labelForType(String type) {
    switch (type) {
      case 'ADMIN_ADD':
        return 'Admin Credit';
      case 'ADMIN_DEDUCT':
        return 'Admin Deduction';
      case 'EARNED':
        return 'Earned via Order';
      case 'REFERRAL':
        return 'Referral Reward';
      case 'REFUND_RESTORE':
        return 'Refund Restore';
      case 'REDEEM_ORDER':
        return 'Redeemed on Order';
      case 'REWARD_REVERSAL':
        return 'Reward Reversal';
      default:
        return type;
    }
  }

  Widget _buildTransactionRow(
    BuildContext context,
    ColorScheme cs,
    FreshPointsTransaction txn,
  ) {
    final isPositive = _isEarnType(txn.transactionType);
    final isAdmin = txn.transactionType == 'ADMIN_ADD' || txn.transactionType == 'ADMIN_DEDUCT';
    final isRedeemOrder = txn.transactionType == 'REDEEM_ORDER';
    final icon = isPositive ? Icons.add_circle_outline : Icons.remove_circle_outline;
    final color = isPositive ? cs.primary : cs.error;
    final hasLongText = (txn.description?.length ?? 0) > 30;
    final isExpanded = _expandedIds.contains(txn.id);

    return GestureDetector(
      onTap: hasLongText
          ? () {
              setState(() {
                if (isExpanded) {
                  _expandedIds.remove(txn.id);
                } else {
                  _expandedIds.add(txn.id);
                }
              });
            }
          : null,
      child: Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Icon(icon, color: color, size: 24),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAdmin && txn.description != null
                          ? txn.description!
                          : isRedeemOrder && txn.description != null
                              ? txn.description!
                              : _labelForType(txn.transactionType),
                      style: TextStyle(
                        color: cs.onSurface,
                        fontSize: 14.sp,
                      ),
                      maxLines: isExpanded ? null : 2,
                      overflow: isExpanded ? null : TextOverflow.ellipsis,
                    ),
                    if (isAdmin && txn.description != null)
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(
                          _labelForType(txn.transactionType),
                          style: TextStyle(
                            color: cs.onSurfaceVariant,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    SizedBox(height: isAdmin && txn.description != null ? 0 : 2.h),
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
              SizedBox(width: 16.w),
              if (hasLongText)
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 20,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              SizedBox(width: 8.w),
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Text(
                  '${isPositive ? '+' : '-'}${txn.points}',
                  style: TextStyle(
                    color: color,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
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
