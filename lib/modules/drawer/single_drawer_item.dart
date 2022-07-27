import 'package:flutter/material.dart';
import 'package:flutter_application_1/localization_helper.dart';

class AppDrawerSingleListItem extends StatefulWidget {
  AppDrawerSingleListItem({ Key? key, required this.title, required this.icon, required this.children, this.targetScreen }) : super(key: key);

  final String title;
  final Icon icon;
  List<Widget>? children;
  final Widget? targetScreen;

  @override
  State<AppDrawerSingleListItem> createState() => _AppDrawerSingleListItemState();
}

class _AppDrawerSingleListItemState extends State<AppDrawerSingleListItem> {
  @override
  Widget build(BuildContext context) {

    bool _isSubMenuItem = widget.children == null;
    
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: ExpansionTile(
        title: Text(AppLocalization.of(context).getTranslatedValue(widget.title) ??  widget.title, style: Theme.of(context).textTheme.bodyText1),
        children: !_isSubMenuItem ? widget.children as List<Widget> : const <Widget>[],
        leading: IconTheme(
          child: widget.icon,
          data: Theme.of(context).iconTheme
        ),
        childrenPadding: !_isSubMenuItem ? const EdgeInsets.only(left: 20) : null,
        trailing: IconTheme(
          child: const Icon(Icons.arrow_forward_ios_outlined, size: 15,),
          data: Theme.of(context).iconTheme
        ),
        onExpansionChanged: widget.targetScreen != null ? (_d) {
          if(Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          Navigator.push(context, MaterialPageRoute(builder: (context) => widget.targetScreen as Widget));
        } : null,
      )
    );
  }
}