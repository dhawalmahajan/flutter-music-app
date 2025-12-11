import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final songNameController = TextEditingController();
  final artistController = TextEditingController();
  Color selectedColor = Pallete.cardColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Song'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DottedBorder(
                options: RectDottedBorderOptions(
                  color: Pallete.borderColor,
                  dashPattern: const [10, 4],
                  padding: const EdgeInsets.all(20),
                  strokeCap: StrokeCap.round,
                ),
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Icon(
                        Icons.folder_open,
                        size: 40,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Select thumbnail File to Upload',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              CustomField(
                hintText: 'Pick Song',
                controller: null,
                readOnly: true,
                onTap: () {},
              ),
              const SizedBox(height: 40),
              CustomField(
                hintText: 'Artist',
                controller: artistController,
              ),
              const SizedBox(height: 20),
              CustomField(
                hintText: 'Song name',
                controller: songNameController,
              ),
              const SizedBox(height: 20),
              ColorPicker(
                pickersEnabled: {
                  ColorPickerType.wheel: true,
                },
                color: selectedColor,
                onColorChanged: (Color color) {
                  setState(() {
                    selectedColor = color;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
