import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/items.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>((event, emit) {
      final updatedItems = Map<int, Items>.from(state.items);
      final updatedQuantities = Map<int, int>.from(state.quantities);

      if (updatedItems.containsKey(event.item.itemId)) {
        updatedQuantities[event.item.itemId] =
            (updatedQuantities[event.item.itemId] ?? 0) + 1;
      } else {
        updatedItems[event.item.itemId] = event.item;
        updatedQuantities[event.item.itemId] = 1;
      }

      emit(state.copyWith(items: updatedItems, quantities: updatedQuantities));
    });

    on<RemoveFromCart>((event, emit) {
      final updatedItems = Map<int, Items>.from(state.items);
      final updatedQuantities = Map<int, int>.from(state.quantities);

      updatedItems.remove(event.item.itemId);
      updatedQuantities.remove(event.item.itemId);

      emit(state.copyWith(items: updatedItems, quantities: updatedQuantities));
    });

    on<UpdateCartQuantity>((event, emit) {
      final updatedQuantities = Map<int, int>.from(state.quantities);
      final currentQty = updatedQuantities[event.item.itemId] ?? 0;
      final newQty = currentQty + event.change;

      if (newQty <= 0) {
        add(RemoveFromCart(event.item));
      } else {
        updatedQuantities[event.item.itemId] = newQty;
        emit(state.copyWith(quantities: updatedQuantities));
      }
    });

    on<ClearCart>((event, emit) {
      emit(const CartState());
    });
  }
}
