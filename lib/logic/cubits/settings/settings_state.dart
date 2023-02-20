part of 'settings_cubit.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final bool isEnabled;
  final bool bankCard;
  final bool cash;
  final bool nonCash;
  final bool savedCard;

  const SettingsLoaded(
      {required this.isEnabled,
      required this.bankCard,
      required this.cash,
      required this.nonCash,
      required this.savedCard});

  @override
  List<Object> get props => [isEnabled, bankCard, cash, nonCash, savedCard];
}

class SettingsSaving extends SettingsState {}

class SettingsSuccessSaved extends SettingsState {}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object> get props => [message];
}
