import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../globals.dart';
import '../../models/items.dart';
import '../../repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc(this.repository) : super(ProductLoading()) {
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final List<Items> items = await repository.getProducts();
        emit(ProductLoaded(items));
      } catch (e) {
        emit(_mapExceptionToState(e, 'LoadProducts'));
      }
    });

    on<RefreshProducts>((event, emit) async {
      try {
        final List<Items> items = await repository.getProducts(
          forceRefresh: true,
        );
        emit(ProductLoaded(items));
      } catch (e) {
        emit(_mapExceptionToState(e, 'RefreshProducts'));
      }
    });

    on<SearchProducts>((event, emit) async {
      if (event.query.trim().isEmpty) {
        add(LoadProducts());
        return;
      }

      emit(ProductLoading());

      try {
        final List<Items> items = await repository.searchProducts(event.query);
        emit(ProductLoaded(items));
      } catch (e) {
        emit(ProductLoaded(const []));
      }
    });
  }

  ProductError _mapExceptionToState(Object e, String functionName) {
    return ProductError(
      e is CustomException
          ? e
          : CustomException(message: e.toString(), functionName: functionName),
    );
  }
}
