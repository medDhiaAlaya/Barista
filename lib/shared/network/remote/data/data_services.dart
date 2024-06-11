import 'data.dart';
import 'data_provider.dart';

class DataService implements Data {
  final Data dataProvider;

  DataService(this.dataProvider);

  factory DataService.instance() => DataService(DataProvider());

  @override
  void initialize() => dataProvider.initialize();


}
