import 'package:equatable/equatable.dart';

abstract class FormSubmissionStatus extends Equatable {
  const FormSubmissionStatus();

  @override
  List<Object> get props => [];
}

class InitialFormStatus extends FormSubmissionStatus {
  const InitialFormStatus();
}

class FormSubmittingStatus extends FormSubmissionStatus {
  const FormSubmittingStatus();
}

class SubmissionSuccessStatus extends FormSubmissionStatus {
  const SubmissionSuccessStatus();
}

class SubmissionFailedStatus extends FormSubmissionStatus {
  final String message;

  const SubmissionFailedStatus(this.message);

  @override
  String toString() {
    return "SubmissionFailedStatus($message)";
  }

  @override
  List<Object> get props => [message];
}
