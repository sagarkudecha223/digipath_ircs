import 'dart:io';

class SelectImageModal{

  final File image;
  late  bool isSelected = false;
  final double size;

  SelectImageModal({

    required this.image,
    required this.isSelected,
    required this.size
  });

}