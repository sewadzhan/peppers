import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pikapika_admin_panel/data/models/order.dart';
import 'package:pikapika_admin_panel/data/repositories/firestore_repository.dart';

part 'order_history_event.dart';
part 'order_history_state.dart';

//Bloc for customer's addresses of delivery
class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final FirestoreRepository firestoreRepository;

  OrderHistoryBloc(this.firestoreRepository) : super(OrderHistoryInitial()) {
    on<LoadOrderHistory>(loadOrderHistoryState);
  }

  //Load customer's addresses from DB
  Future<void> loadOrderHistoryState(
      LoadOrderHistory event, Emitter<OrderHistoryState> emit) async {
    if (state is OrderHistoryInitial) {
      try {
        emit(OrderHistoryLoading());

        List<Order> orders =
            await firestoreRepository.getOrderHistoryOfUser(event.phoneNumber);

        emit(OrderHistoryLoaded(orders));
      } catch (e) {
        emit(const OrderHistoryErrorState("Произошла непредвидимая ошибка"));
      }
    }
  }
}
