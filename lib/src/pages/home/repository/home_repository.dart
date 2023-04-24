import 'package:loja/src/models/category_model.dart';
import 'package:loja/src/models/item_model.dart';
import 'package:loja/src/pages/home/result/home_result.dart';
import 'package:loja/src/services/http_manager.dart';

import '../../../constants/endpoints.dart';

class HomeRepository {
  final HttpManager _httpManager = HttpManager();
  Future<HomeResult<CategoryModel>> getAllCategories() async {
    final result = await _httpManager.restRequest(
        url: Endpoints.getAllCategories, method: HttpMethods.post, body: {});
    if (result != null) {
      List<CategoryModel> data =
          (List<Map<String, dynamic>>.from(result['result']))
              .map(CategoryModel.fromJson)
              .toList();
      return HomeResult<CategoryModel>.success(data);
    } else {
      return HomeResult.error('Ocorreu um erro ao recuperar itens');
    }
  }

  Future<HomeResult<ItemModel>> getAllProducts(
      Map<String, dynamic> body) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.getAllProducts, method: HttpMethods.post, body: body);
    if (result != null) {
      List<ItemModel> data = List<Map<String, dynamic>>.from(result['result'])
          .map(ItemModel.fromJson)
          .toList();
      return HomeResult.success(data);
    } else {
      return HomeResult.error('Ocorreu um erro ao recuperar itens');
    }
  }
}
