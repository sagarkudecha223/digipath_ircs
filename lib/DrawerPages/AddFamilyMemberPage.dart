import 'package:digipath_ircs/Design/GlobalAppBar.dart';
import 'package:digipath_ircs/Design/TopPageTextViews.dart';
import 'package:flutter/material.dart';

class AddFamilyMemberPage extends StatefulWidget {
  const AddFamilyMemberPage({Key? key}) : super(key: key);

  @override
  State<AddFamilyMemberPage> createState() => _AddFamilyMemberPageState();
}

class _AddFamilyMemberPageState extends State<AddFamilyMemberPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.indigo.shade100,
        child: Column(
          children: [
            TopPageTextViews('Add Family Member', 'family member registration'),

          ],
        ),
      ),
    );
  }
}
