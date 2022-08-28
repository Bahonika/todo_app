import 'package:flutter/material.dart';
import 'package:todo_app/internal/config.dart';

class TestBanner extends StatefulWidget {
  final Widget child;

  const TestBanner({Key? key, required this.child}) : super(key: key);

  @override
  State<TestBanner> createState() => _TestBannerState();
}

class _TestBannerState extends State<TestBanner> {
  final environmentConfiguration = EnvironmentConfiguration();

  @override
  Widget build(BuildContext context) {
    return EnvironmentConfiguration.isTest
        ? Banner(
            message: "Dev",
            location: BannerLocation.topEnd,
            child: widget.child,
          )
        : SizedBox(
            child: widget.child,
          );
  }
}
