import 'package:flutter/material.dart';
import '../../../core/theme/skye_theme.dart';
import '../models/activity_model.dart';

class AddActivityDialog extends StatefulWidget {
  final Activity? editingActivity;
  final Function(Activity) onSave;

  const AddActivityDialog({
    Key? key,
    this.editingActivity,
    required this.onSave,
  }) : super(key: key);

  @override
  State<AddActivityDialog> createState() => _AddActivityDialogState();
}

class _AddActivityDialogState extends State<AddActivityDialog> {
  late TextEditingController _nameController;
  late double _minTemp;
  late double _maxTemp;
  late double _maxWind;
  late double _minVisibility;
  late double _maxUV;

  @override
  void initState() {
    super.initState();
    if (widget.editingActivity != null) {
      _nameController = TextEditingController(text: widget.editingActivity!.name);
      _minTemp = widget.editingActivity!.minTemp;
      _maxTemp = widget.editingActivity!.maxTemp;
      _maxWind = widget.editingActivity!.maxWind;
      _minVisibility = widget.editingActivity!.minVisibility;
      _maxUV = widget.editingActivity!.maxUV;
    } else {
      _nameController = TextEditingController();
      _minTemp = 15.0;
      _maxTemp = 25.0;
      _maxWind = 10.0;
      _minVisibility = 5.0;
      _maxUV = 6.0;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an activity name')),
      );
      return;
    }

    final activity = Activity(
      id: widget.editingActivity?.id,
      name: _nameController.text.trim(),
      minTemp: _minTemp,
      maxTemp: _maxTemp,
      maxWind: _maxWind,
      minVisibility: _minVisibility,
      maxUV: _maxUV,
      createdAt: widget.editingActivity?.createdAt,
    );

    widget.onSave(activity);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SkyeColors.surfaceDark,
      appBar: AppBar(
        backgroundColor: SkyeColors.surfaceDark,
        elevation: 0,
        title: Text(widget.editingActivity != null ? 'Edit Activity' : 'Add New Activity', style: SkyeTypography.title),
        leading: IconButton(
          icon: Icon(Icons.close, color: SkyeColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(widget.editingActivity != null ? 'Update' : 'Save', style: SkyeTypography.label.copyWith(color: SkyeColors.textSecondary)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),

              // Activity Name
              Text('Activity Name', style: SkyeTypography.label.copyWith(color: SkyeColors.textSecondary)),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                style: SkyeTypography.body.copyWith(color: SkyeColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'e.g., Morning Run',
                  hintStyle: SkyeTypography.body.copyWith(color: SkyeColors.textMuted),
                  filled: true,
                  fillColor: SkyeColors.behindContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: SkyeColors.glassBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: SkyeColors.glassBorder),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Ideal Temperature Range
              Text('Ideal Temperature Range', style: SkyeTypography.label.copyWith(color: SkyeColors.textSecondary)),
              const SizedBox(height: 8),
              RangeSlider(
                values: RangeValues(_minTemp, _maxTemp),
                min: -20,
                max: 40,
                onChanged: (values) {
                  setState(() {
                    _minTemp = values.start;
                    _maxTemp = values.end;
                  });
                },
                activeColor: SkyeColors.textSecondary,
                inactiveColor: SkyeColors.behindContainer,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('${_minTemp.toStringAsFixed(1)}°C - ${_maxTemp.toStringAsFixed(1)}°C', style: SkyeTypography.caption.copyWith(color: SkyeColors.textSecondary)),
              ),
              const SizedBox(height: 20),

              // Max Wind
              Text('Max Wind Speed (m/s)', style: SkyeTypography.label.copyWith(color: SkyeColors.textSecondary)),
              const SizedBox(height: 8),
              Slider(
                value: _maxWind,
                min: 0,
                max: 20,
                onChanged: (value) {
                  setState(() {
                    _maxWind = value;
                  });
                },
                activeColor: SkyeColors.textSecondary,
                inactiveColor: SkyeColors.behindContainer,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('${_maxWind.toStringAsFixed(1)} m/s', style: SkyeTypography.caption.copyWith(color: SkyeColors.textSecondary)),
              ),
              const SizedBox(height: 20),

              // Min Visibility
              Text('Min Visibility (km)', style: SkyeTypography.label.copyWith(color: SkyeColors.textSecondary)),
              const SizedBox(height: 8),
              Slider(
                value: _minVisibility,
                min: 0,
                max: 50,
                onChanged: (value) {
                  setState(() {
                    _minVisibility = value;
                  });
                },
                activeColor: SkyeColors.textSecondary,
                inactiveColor: SkyeColors.behindContainer,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('${_minVisibility.toStringAsFixed(1)} km', style: SkyeTypography.caption.copyWith(color: SkyeColors.textSecondary)),
              ),
              const SizedBox(height: 20),

              // Max UV
              Text('Max UV Index', style: SkyeTypography.label.copyWith(color: SkyeColors.textSecondary)),
              const SizedBox(height: 8),
              Slider(
                value: _maxUV,
                min: 0,
                max: 11,
                onChanged: (value) {
                  setState(() {
                    _maxUV = value;
                  });
                },
                activeColor: SkyeColors.textSecondary,
                inactiveColor: SkyeColors.behindContainer,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('${_maxUV.toStringAsFixed(1)}', style: SkyeTypography.caption.copyWith(color: SkyeColors.textSecondary)),
              ),
              const SizedBox(height: 24),

              const SizedBox(height: 12),
              // Buttons at bottom handled by AppBar action; also provide a visible save button
              Center(
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SkyeColors.textSecondary,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(widget.editingActivity != null ? 'Update Activity' : 'Save Activity', style: SkyeTypography.subtitle.copyWith(color: SkyeColors.deepSpace)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
