import 'package:flutter/material.dart';
import 'package:product_catalog/models/product.dart';
import 'package:product_catalog/services/api_services.dart';
import 'package:product_catalog/services/debouncer.dart';

enum ViewState {
  success,
  loading,
  empty,
  error,
}

class ProductMenuController extends ChangeNotifier {

  final APIServices apiServices = APIServices();
  final Debouncer debouncer = Debouncer(delay: Duration(milliseconds: 500));
  ViewState state = ViewState.loading;

  List<Product> loadProducts = [];

  String selectedSort = 'default';
  bool isLoading = false;
  bool isSearching = false;
  // bool isFilterActive = false;
  bool hasMore = true;
  int itemSkip = 0;
  int itemLimit = 10;

  @override
  void dispose() {
    debouncer.cancel();
    super.dispose();
  }

  // Display items at the start
  Future<void> loadItems() async {
    if (isLoading || !hasMore || isSearching)
      return;

    if (loadProducts.isEmpty) { // display state loading before loading the list
      state = ViewState.loading;
      notifyListeners();
    } else {
      isLoading = true;
      notifyListeners();
    }

    try {

      String? sort;
      String? order;

      if (selectedSort == 'title asc') {
        sort = 'title';
        order = 'asc';
      } else if (selectedSort == 'title desc') {
        sort = 'title';
        order = 'desc';
      } else if (selectedSort == 'price asc') {
        sort = 'price';
        order = 'asc';
      } else if (selectedSort == 'price desc') {
        sort = 'price';
        order = 'desc';
      }

      final nextProducts = await apiServices.fetchProducts(
        limit: itemLimit,
        skip: itemSkip,
        sortBy: sort,
        sortOrder: order,
      );

      itemSkip += itemLimit;
      isLoading = false;

      if (nextProducts.length < itemLimit) {
        hasMore = false; 
      }
      loadProducts.addAll(nextProducts);

      if (loadProducts.isEmpty) { // display state empty if the list is empty 
        state = ViewState.empty;
      } else {
        state = ViewState.success;
      }

    } catch (e) {
      print('Error loading items: $e');

      if (loadProducts.isEmpty) { // display state error if there is an error
        state = ViewState.error;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Display items after refresh
  Future<void> refreshItem() async {
    loadProducts.clear(); 
    itemSkip = 0;         
    hasMore = true;
    isSearching = false;
    notifyListeners();

    await loadItems();
  }

  // Display items after sort updates
  void sortChanged(String? newSort) {
    if (newSort == null || newSort == selectedSort) 
      return;

    selectedSort = newSort;
    loadProducts.clear(); 
    itemSkip = 0;         
    hasMore = true;
    notifyListeners();

    loadItems();
  }

  // Handle search input
  Future<void> searchInput(String query) async {
    debouncer.run(() async {
      final trimmed = query.trim();

      if (trimmed.isEmpty) {
        isSearching = false;
        loadProducts.clear();
        itemSkip = 0;
        hasMore = true;
        notifyListeners();
        loadItems();

        return;
      }

      isSearching = true;
      isLoading = true;
      hasMore = false;
      notifyListeners();

      try {
        final searchResults = await apiServices.searchProducts(trimmed);
        loadProducts = searchResults;
      } catch (e) {
        print('Search error: $e');
      } finally {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  // Retry if fail to load items
  Future<void> retry() async {
    String errorMessage = 'Please try again';
    await loadItems();
  }
}