part of 'cart_bloc.dart';

class CartState extends Equatable {
  final Map<int, Items> items;
  final Map<int, int> quantities;

  const CartState({this.items = const {}, this.quantities = const {}});

  double get totalAmount {
    double total = 0;
    items.forEach((id, item) {
      total += item.costPrice * (quantities[id] ?? 0);
    });
    return total;
  }

  int get totalItemsCount {
    int count = 0;
    quantities.values.forEach((qty) => count += qty);
    return count;
  }

  List<Items> get cartList => items.values.toList();

  CartState copyWith({Map<int, Items>? items, Map<int, int>? quantities}) {
    return CartState(
      items: items ?? this.items,
      quantities: quantities ?? this.quantities,
    );
  }

  @override
  List<Object> get props => [items, quantities];
}
