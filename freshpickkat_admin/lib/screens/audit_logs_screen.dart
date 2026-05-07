import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_state_view.dart';

class AuditLogsScreen extends StatefulWidget {
  const AuditLogsScreen({super.key});

  @override
  State<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends State<AuditLogsScreen> {
  final _client = ServerpodAdminClient().client;
  late Future<List<AdminAuditLogEntry>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadAuditLogs();
  }

  Future<List<AdminAuditLogEntry>> _loadAuditLogs() async {
    final uid = AdminSessionService.requireUid();
    final idToken = await AdminSessionService.requireIdToken(
      forceRefresh: false,
    );
    return _client.admin.getAuditLogs(uid, idToken, limit: 100);
  }

  Future<void> _reload() async {
    setState(() {
      _future = _loadAuditLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: const Text('Audit Logs'),
        actions: [
          IconButton(onPressed: _reload, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder<List<AdminAuditLogEntry>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return AdminStateView.error(
              message: snapshot.error.toString(),
              onRetry: () {
                setState(() {
                  _future = _loadAuditLogs();
                });
              },
            );
          }
          final rows = snapshot.data ?? [];
          if (rows.isEmpty) {
            return const AdminStateView(
              title: 'No logs yet',
              message: 'Admin activity will appear here.',
              icon: Icons.receipt_long_outlined,
            );
          }
          return RefreshIndicator(
            onRefresh: _reload,
            child: AdminResponsive.constrainContent(
              context: context,
              child: ListView.builder(
                padding: AdminResponsive.pagePadding(context),
                itemCount: rows.length,
                itemBuilder: (context, index) {
                  final row = rows[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      isThreeLine: true,
                      title: Text(
                        '${row.action} ${row.entityType}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'Entity: ${row.entityId}\nActor: ${row.actorUid}',
                      ),
                      trailing: SizedBox(
                        width: 96,
                        child: Text(
                          row.createdAt.replaceFirst('T', '\n'),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
