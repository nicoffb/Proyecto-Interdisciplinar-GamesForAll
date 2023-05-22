import 'dart:ffi';

import 'package:file_picker/file_picker.dart';
import 'package:gamesforall_frontend/blocs/productList/product_bloc.dart';
import 'package:gamesforall_frontend/models/product_request.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../models/product_detail_response.dart';
import '../models/product_page_response.dart';
import '../rest/rest_client.dart';

const _postLimit = 20;

@singleton
class ProductRepository {
  late RestAuthenticatedClient server;
  ProductRepository() {
    server = GetIt.I.get<RestAuthenticatedClient>();
  }

  //OBTENER LAS PAGINAS DE LOS PRODUCTOS DEPENDIENDO DEL LISTADO
  Future<ProductPageResponse> getProductList(int page,
      {ProductType productType = ProductType.search}) async {
    String urlString;

    switch (productType) {
      case ProductType.search:
        urlString = '/product/search/?page=$page&search=sold:false';
        break;
      case ProductType.favorites:
        urlString = '/favorites/?page=$page';
        break;
      case ProductType.myproducts:
        urlString = '/myproducts/?page=$page';
        break;
    }

    var jsonResponse = await server.get(urlString);
    ProductPageResponse pagedProducts =
        ProductPageResponse.fromJson(jsonDecode(jsonResponse));

    return pagedProducts;
  }

  // Método para obtener un producto por su ID
  Future<ProductDetailsResponse> getProductById(int id) async {
    String urlString = '/product/$id';

    var jsonResponse = await server.get(urlString);
    ProductDetailsResponse product =
        ProductDetailsResponse.fromJson(jsonDecode(jsonResponse));

    return product;
  }

  Future<ProductDetailsResponse> addProduct(ProductRequest productRequest,
<<<<<<< HEAD
      PlatformFile file, String accessToken) async {
    String url = 'http://localhost:8080/product/';
=======
    PlatformFile file, String accessToken) async {
    String url = 'http://localhost:8080/product';
>>>>>>> origin/favorites

    var jsonResponse =
        await server.postMultiPart(url, productRequest, file, accessToken);
    return ProductDetailsResponse.fromJson(jsonDecode(jsonResponse));
  }








  Future<void> addToFavorites(int productId, User user) async {
  String url = 'http://localhost:8080/favorites/$productId';

  var response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to add product to favorites');
  }
}





}
