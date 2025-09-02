import 'dart:math';
import 'package:fakhama_amiradmin_app/features/products/controllers/product_controller.dart';
import 'package:fakhama_amiradmin_app/features/products/models/products_model.dart';
import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';

import '../../../core/class/statusrequest.dart';
import '../../../core/constants/utils/widgets/snak_bar.dart';
import '../../../services/data/data_api.dart';
import '../../../services/helper_function.dart';

class AddEditProductController extends GetxController {
  // Text Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController skuController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  // Observable variables
  var statusRequest = StatusRequest.none.obs;
  var isEditMode = false.obs;
  var productId = 0.obs;
  var isActive = true.obs;

  // Dependencies
  final DataApi dataApi = DataApi(Get.find());
  ProductController productsController = Get.find<ProductController>();

  @override
  void onInit() {
    super.onInit();
    // Check if we're in edit mode
    if (Get.arguments != null && Get.arguments['product'] != null) {
      isEditMode.value = true;
      _populateFields(Get.arguments['product']);
    } else {
      _generateSKU();
    }
  }

  void _populateFields(ProductModel product) {
    productId.value = product.id ?? 0;
    nameController.text = product.name;
    descriptionController.text = product.description ?? '';
    skuController.text = product.sku;
    priceController.text = product.price.toString();
    quantityController.text = product.quantity?.toString() ?? '';
    categoryController.text = product.categoryName ?? '';
    isActive.value = product.isActive;
  }

  void _generateSKU() {
    // Generate a random SKU with format: PRD + 3 random digits
    final random = Random();
    final randomNumber = random.nextInt(900) + 100; // Generates 100-999
    skuController.text = 'PRD$randomNumber';
  }

  void regenerateSKU() {
    _generateSKU();
  }

  // Validation methods
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال اسم المنتج';
    }

    return null;
  }

  String? validateSKU(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال رمز المنتج (SKU)';
    }

    return null;
  }

  String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال سعر المنتج';
    }
    final price = double.tryParse(value);
    if (price == null || price <= 0) {
      return 'يرجى إدخال سعر صحيح أكبر من صفر';
    }
    return null;
  }

  bool validateForm() {
    return validateName(nameController.text) == null &&
        validateSKU(skuController.text) == null &&
        validatePrice(priceController.text) == null;
  }

  Map<String, dynamic> _buildRequestData() {
    return {
      'name': nameController.text.trim(),
      'description': descriptionController.text.trim(),
      'sku': skuController.text.trim(),
      'price': double.tryParse(priceController.text) ?? 0.0,
      'quantity': int.tryParse(quantityController.text) ?? 0,
      // 'category': categoryController.text.trim(),
      // 'is_active': isActive.value,
    };
  }

  Future<void> saveProduct() async {
    if (!validateForm()) {
      showSnakBar(
        title: 'خطأ',
        msg: 'يرجى التأكد من صحة جميع البيانات المدخلة',
        color: Colors.red,
      );
      return;
    }

    final data = _buildRequestData();
    await handleRequestfunc(
      hideLoading: false,
      status: (status) => statusRequest.value = status,
      apiCall: () async {
        if (isEditMode.value) {
          return await dataApi.editProduct(productId.value, data);
        } else {
          return await dataApi.addProduct(data);
        }
      },
      onSuccess: (res) {
        productsController.fetchData(hideLoading: true);
        Get.back();
        showSnakBar(
          title: 'نجح',
          msg: isEditMode.value
              ? 'تم تحديث المنتج بنجاح'
              : 'تم إنشاء المنتج بنجاح',
          color: Colors.green,
        );
      },
      onError: showError,
    );
  }

  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    skuController.clear();
    priceController.clear();
    quantityController.clear();
    categoryController.clear();
    isActive.value = true;
    if (!isEditMode.value) {
      _generateSKU();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    skuController.dispose();
    priceController.dispose();
    quantityController.dispose();
    categoryController.dispose();
    super.onClose();
  }
}
