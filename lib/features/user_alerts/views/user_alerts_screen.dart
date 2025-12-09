import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/user_alerts_viewmodel.dart';
import '../widgets/user_alert_card.dart';
import '../widgets/create_alert_dialog.dart';
import '../../../core/theme/skye_colors.dart';

class UserAlertsScreen extends ConsumerWidget {
  const UserAlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAlertsState = ref.watch(userAlertsProvider);

    return Scaffold(
      backgroundColor: SkyeColors.deepSpace,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Weather Alerts',
          style: TextStyle(
            color: SkyeColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: SkyeColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: userAlertsState.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: SkyeColors.skyBlue,
                    ),
                  )
                : userAlertsState.alerts.isEmpty
                    ? _buildEmptyState(context, ref)
                    : _buildAlertsList(context, ref, userAlertsState.alerts),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: SkyeColors.surfaceDark,
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showCreateAlertDialog(context, ref),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SkyeColors.skyBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Create Alert',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: SkyeColors.skyBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                size: 64,
                color: SkyeColors.skyBlue,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Weather Alerts Yet',
              style: TextStyle(
                color: SkyeColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Create custom alerts to get notified when weather conditions match your preferences',
              style: TextStyle(
                color: SkyeColors.textSecondary,
                fontSize: 15,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsList(BuildContext context, WidgetRef ref, alerts) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: UserAlertCard(
            alert: alert,
            onToggle: (value) {
              ref.read(userAlertsProvider.notifier).toggleAlertEnabled(alert.id, value);
            },
            onEdit: () => _showEditAlertDialog(context, ref, alert),
            onDelete: () => _confirmDelete(context, ref, alert),
          ),
        );
      },
    );
  }

  void _showCreateAlertDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const CreateAlertDialog(),
    );
  }

  void _showEditAlertDialog(BuildContext context, WidgetRef ref, alert) {
    showDialog(
      context: context,
      builder: (context) => CreateAlertDialog(existingAlert: alert),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: SkyeColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Delete Alert?',
          style: TextStyle(color: SkyeColors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete "${alert.name}"?',
          style: TextStyle(color: SkyeColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: SkyeColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(userAlertsProvider.notifier).deleteAlert(alert.id);
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: SkyeColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
