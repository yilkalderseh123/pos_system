import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../models/menu_item.dart';

abstract class MenuEvent {}

class AddMenuItem extends MenuEvent {
  final MenuItem item;
  AddMenuItem(this.item);
}

class MenuState {
  final List<MenuItem> menuItems;

  MenuState({this.menuItems = const []});
}

class MenuBloc extends HydratedBloc<MenuEvent, MenuState> {
  MenuBloc() : super(MenuState());

  @override
  Stream<MenuState> mapEventToState(MenuEvent event) async* {
    if (event is AddMenuItem) {
      final updatedMenu = List<MenuItem>.from(state.menuItems)..add(event.item);
      yield MenuState(menuItems: updatedMenu);
    }
  }

  @override
  MenuState? fromJson(Map<String, dynamic> json) {
    if (json['menuItems'] != null) {
      final menuItems = (json['menuItems'] as List)
          .map((item) => MenuItem.fromJson(item))
          .toList();
      return MenuState(menuItems: menuItems);
    }
    return MenuState();
  }

  @override
  Map<String, dynamic>? toJson(MenuState state) {
    return {'menuItems': state.menuItems.map((item) => item.toJson()).toList()};
  }
}
