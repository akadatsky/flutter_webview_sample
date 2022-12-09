import 'package:flutter/material.dart';
import 'package:flutter_webview_sample/data_source/data_source.dart';
import 'package:flutter_webview_sample/res/colors.dart';
import 'package:flutter_webview_sample/res/constants.dart';
import 'package:flutter_webview_sample/res/styles.dart';
import 'package:flutter_webview_sample/webview_page.dart';
import 'package:flutter_webview_sample/widgets/color_on_tap_divider_list.dart';
import 'package:flutter_webview_sample/widgets/custom_web_view.dart';
import 'package:flutter_webview_sample/widgets/divider.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  final List<ResourceInfo> resources = DataSource().resources;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView sample'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: AppColors.snow,
              child: ColorOnTapDividerListView(
                shrinkWrap: false,
                onTap: (index) async {
                  _launchUrl(
                    context,
                    resources[index].url,
                    resources[index].title,
                  );
                },
                defaultColor: AppColors.white,
                itemBuilder: (_, index) {
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: subLargePadding,
                          color: AppColors.snow,
                        ),
                        const SimpleDivider(AppColors.lightGray),
                        ResourceMenuItem(
                          resources[index].title,
                        ),
                      ],
                    );
                  }
                  if (index == resources.length - 1) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ResourceMenuItem(
                          resources[index].title,
                        ),
                        const SimpleDivider(AppColors.lightGray),
                        Container(
                          height: subLargePadding,
                          color: AppColors.snow,
                        ),
                      ],
                    );
                  }
                  return ResourceMenuItem(resources[index].title);
                },
                dividerBuilder: (index) => const Padding(
                  padding: EdgeInsets.only(left: middlePadding),
                  child: SimpleDivider(AppColors.lightGray),
                ),
                itemCount: resources.length,
                highlightColor: AppColors.white_20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchUrl(
    BuildContext context,
    String url,
    String title,
  ) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebviewPage(
          context: context,
          title: title,
          rootNavigator: true,
          isModalScreen: true,
          isShowControls: true,
          screenData: CustomWebViewScreenData(initUrl: url),
        ),
      ),
    );
  }
}

class ResourceMenuItem extends StatelessWidget {
  final String text;

  const ResourceMenuItem(
    this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: const EdgeInsets.only(left: middlePadding),
      child: Text(
        text,
        style: Styles.body1,
      ),
    );
  }
}
