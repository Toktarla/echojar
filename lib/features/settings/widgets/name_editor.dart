import 'package:echojar/app/theme/app_colors.dart';
import 'package:echojar/common/presentation/widgets/glass_container.dart';
import 'package:flutter/material.dart';

class NameEditor extends StatefulWidget {
  final String name;
  final void Function(String) onChanged;

  const NameEditor({
    super.key,
    required this.name,
    required this.onChanged,
  });

  @override
  State<NameEditor> createState() => _NameEditorState();
}

class _NameEditorState extends State<NameEditor> {
  bool isEditing = false;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.name);
  }

  @override
  void didUpdateWidget(covariant NameEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.name != oldWidget.name) {
      controller.text = widget.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const Icon(Icons.person),
            const SizedBox(width: 12),
            Expanded(
              child: isEditing
                  ? TextField(
                controller: controller,
                onChanged: widget.onChanged,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  focusColor: AppColors.primary,
                  focusedBorder: OutlineInputBorder(),
                ),
              )
                  : Text(
                widget.name.isNotEmpty ? widget.name : 'Not set',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(isEditing ? Icons.check : Icons.edit),
              onPressed: () {
                if (isEditing) widget.onChanged(controller.text.trim());
                setState(() => isEditing = !isEditing);
              },
            ),
          ],
        ),
      ),
    );
  }
}
