import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stac/src/framework/stac.dart';
import 'package:stac/src/services/stac_network_service.dart';
import 'package:stac_models/stac_models.dart';

class StacView extends StatelessWidget {
  const StacView({
    super.key,
    required this.screenName,
    this.headers,
    this.query,
    this.options,
  });

  final String screenName;

  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? query;
  final StacOptions? options;

  @override
  Widget build(BuildContext context) {
    final StacOptions? opts = options;
    final String fetchUrl =
        'https://us-central1-stac-7ad77.cloudfunctions.net/getScreenByName';

    final request = StacNetworkRequest(
      url: fetchUrl,
      method: Method.get,
      queryParameters: <String, dynamic>{
        'projectId': opts?.projectId,
        'screenName': screenName,
        ...?query,
      },
    );

    return FutureBuilder(
      future: StacNetworkService.request(context, request),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jsonString =
              snapshot.data?.data['data']['latestJson']['jsonString'];
          return Stac.fromJson(jsonDecode(jsonString), context) ??
              const SizedBox();
        }
        return const SizedBox();
      },
    );
  }
}
