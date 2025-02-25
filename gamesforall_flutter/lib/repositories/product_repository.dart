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
  Future<ProductDetailsResponse> getProductById(int productId) async {
    String urlString = '/product/$productId';

    var jsonResponse = await server.get(urlString);
    ProductDetailsResponse product =
        ProductDetailsResponse.fromJson(jsonDecode(jsonResponse));

    return product;
  }

  Future<ProductDetailsResponse> addProduct(ProductRequest productRequest,
      PlatformFile file, String accessToken) async {
    String url = 'http://10.0.2.2:8080/product/';
    //String url = 'http://localhost:8080/product/';

    var jsonResponse =
        await server.postMultiPart(url, productRequest, file, accessToken);
    return ProductDetailsResponse.fromJson(jsonDecode(jsonResponse));
  }

  Future<ProductDetailsResponse> editProduct(
      int id, ProductRequest productRequest) async {
    String url = '/product/$id';

    var jsonResponse = await server.put(url, productRequest);
    return ProductDetailsResponse.fromJson(jsonDecode(jsonResponse));
  }

  Future<void> addToFavorites(int productId) async {
    String url = '/favorites/$productId';

    var jsonResponse = await server.post(url, null);
  }

  Future<void> removeFromFavorites(int productId) async {
    String url = '/favorites/$productId';

    var jsonResponse = await server.delete(url);
  }

  Future<List<ProductDetailsResponse>> getUserFavorites() async {
    String urlString = '/favoritesnotpaged/';

    var jsonResponse = await server.get(urlString);
    List<dynamic> jsonList = jsonDecode(jsonResponse);
    List<ProductDetailsResponse> favList =
        jsonList.map((item) => ProductDetailsResponse.fromJson(item)).toList();

    return favList;
  }
}
