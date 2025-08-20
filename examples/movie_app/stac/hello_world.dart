import 'package:stac_models/stac_models.dart';

StacWidget helloWorld() {
  return StacScaffold(body: StacCenter(child: StacText(data: 'Hello, world!')));
}
