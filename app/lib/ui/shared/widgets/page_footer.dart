import 'package:flutter/material.dart';

import 'wide_page_footer.dart';
import 'narrow_page_footer.dart';

class PageFooter extends StatefulWidget {
  const PageFooter({
    super.key,
  });

  @override
  State<PageFooter> createState() => _PageFooterState();
}

class _PageFooterState extends State<PageFooter> {
  bool wideScreen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    wideScreen = MediaQuery.sizeOf(context).width > 610;
  }

  @override
  Widget build(BuildContext context) {
    if (wideScreen) {
      return WidePageFooter();
    } else {
      return NarrowPageFooter();
    }
  }
}