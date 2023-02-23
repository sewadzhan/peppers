import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pikapika_admin_panel/data/models/order.dart';
import 'package:pikapika_admin_panel/data/repositories/firestore_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final FirestoreRepository firestoreRepository;

  OrderBloc(this.firestoreRepository) : super(OrderInitialState()) {
    on<LoadOrders>(loadOrdersToState);
  }

  //Load the actual list of orders from Firestore
  Future<void> loadOrdersToState(
      LoadOrders event, Emitter<OrderState> emit) async {
    try {
      emit(OrderLoadingState());

      final List<Order> orders = await firestoreRepository.getAllOrders();

      emit(OrderLoadedState(orders));
    } catch (e) {
      emit(OrderErrorState(e.toString()));
    }
  }
}
