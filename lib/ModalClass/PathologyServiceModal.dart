class PathologyServiceModal{

  final int amount;
  late int itemCount = 0;
  final String name;
  final String id;
  final String servicemapid;
  late  String isSelected;
  late bool isVisible = false;
  final String isPackage;

   PathologyServiceModal({
      required this.amount,
      required this.name,
      required this.id,
      required this.servicemapid,
      required this.isSelected,
      required this.isPackage,

  });

}