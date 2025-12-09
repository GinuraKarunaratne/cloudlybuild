import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/user_alert_model.dart';
import '../viewmodels/user_alerts_viewmodel.dart';
import '../../../core/theme/skye_theme.dart';

class CreateAlertDialog extends ConsumerStatefulWidget {
  final UserAlertModel? existingAlert;

  const CreateAlertDialog({super.key, this.existingAlert});

  @override
  ConsumerState<CreateAlertDialog> createState() => _CreateAlertDialogState();
}

class _CreateAlertDialogState extends ConsumerState<CreateAlertDialog> {
  late TextEditingController _nameController;
  late TextEditingController _thresholdController;
  late AlertConditionType _selectedCondition;
  late AlertOperator _selectedOperator;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingAlert?.name ?? '');
    _thresholdController = TextEditingController(
      text: widget.existingAlert?.threshold.toString() ?? '',
    );
    _selectedCondition = widget.existingAlert?.conditionType ?? AlertConditionType.temperature;
    _selectedOperator = widget.existingAlert?.operator ?? AlertOperator.lessThan;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _thresholdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: SkyeColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.notifications_active_rounded,
                    color: SkyeColors.skyBlue,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.existingAlert == null ? 'Create Alert' : 'Edit Alert',
                    style: TextStyle(
                      color: SkyeColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Alert Name',
                style: TextStyle(
                  color: SkyeColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                style: TextStyle(color: SkyeColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'e.g., Cold Weather Alert',
                  hintStyle: TextStyle(color: SkyeColors.textSecondary.withAlphaFromOpacity(0.5)),
                  filled: true,
                  fillColor: Colors.white.withAlphaFromOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Condition Type',
                style: TextStyle(
                  color: SkyeColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildConditionTypeDropdown(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Operator',
                          style: TextStyle(
                            color: SkyeColors.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildOperatorDropdown(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Threshold',
                          style: TextStyle(
                            color: SkyeColors.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _thresholdController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: TextStyle(color: SkyeColors.textPrimary),
                          decoration: InputDecoration(
                            hintText: '22.0',
                            hintStyle: TextStyle(color: SkyeColors.textSecondary.withAlphaFromOpacity(0.5)),
                            filled: true,
                            fillColor: Colors.white.withAlphaFromOpacity(0.05),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            suffixText: _getUnit(),
                            suffixStyle: TextStyle(color: SkyeColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: SkyeColors.textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveAlert,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SkyeColors.skyBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        widget.existingAlert == null ? 'Create' : 'Update',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConditionTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withAlphaFromOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButton<AlertConditionType>(
        value: _selectedCondition,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: SkyeColors.surfaceDark,
        style: TextStyle(color: SkyeColors.textPrimary, fontSize: 16),
        items: AlertConditionType.values.map((type) {
          return DropdownMenuItem(
            value: type,
            child: Text(_getConditionName(type)),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedCondition = value);
          }
        },
      ),
    );
  }

  Widget _buildOperatorDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withAlphaFromOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButton<AlertOperator>(
        value: _selectedOperator,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: SkyeColors.surfaceDark,
        style: TextStyle(color: SkyeColors.textPrimary, fontSize: 16),
        items: AlertOperator.values.map((op) {
          return DropdownMenuItem(
            value: op,
            child: Text(_getOperatorSymbol(op)),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedOperator = value);
          }
        },
      ),
    );
  }

  String _getConditionName(AlertConditionType type) {
    switch (type) {
      case AlertConditionType.temperature:
        return 'Temperature';
      case AlertConditionType.feelsLike:
        return 'Feels Like';
      case AlertConditionType.humidity:
        return 'Humidity';
      case AlertConditionType.windSpeed:
        return 'Wind Speed';
      case AlertConditionType.precipitation:
        return 'Precipitation';
    }
  }

  String _getOperatorSymbol(AlertOperator op) {
    switch (op) {
      case AlertOperator.lessThan:
        return 'Less than (<)';
      case AlertOperator.greaterThan:
        return 'Greater than (>)';
      case AlertOperator.equals:
        return 'Equals (=)';
    }
  }

  String _getUnit() {
    switch (_selectedCondition) {
      case AlertConditionType.temperature:
      case AlertConditionType.feelsLike:
        return '°C';
      case AlertConditionType.humidity:
      case AlertConditionType.precipitation:
        return '%';
      case AlertConditionType.windSpeed:
        return 'm/s';
    }
  }

  void _saveAlert() {
    if (_nameController.text.isEmpty || _thresholdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all fields'),
          backgroundColor: SkyeColors.error,
        ),
      );
      return;
    }

    final threshold = double.tryParse(_thresholdController.text);
    if (threshold == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a valid number'),
          backgroundColor: SkyeColors.error,
        ),
      );
      return;
    }

    final alert = UserAlertModel(
      id: widget.existingAlert?.id,
      name: _nameController.text,
      conditionType: _selectedCondition,
      operator: _selectedOperator,
      threshold: threshold,
      isEnabled: widget.existingAlert?.isEnabled ?? true,
      createdAt: widget.existingAlert?.createdAt,
      lastTriggered: widget.existingAlert?.lastTriggered,
    );

    if (widget.existingAlert == null) {
      ref.read(userAlertsProvider.notifier).createAlert(alert);
    } else {
      ref.read(userAlertsProvider.notifier).updateAlert(widget.existingAlert!.id, alert);
    }

    Navigator.pop(context);
  }
}

