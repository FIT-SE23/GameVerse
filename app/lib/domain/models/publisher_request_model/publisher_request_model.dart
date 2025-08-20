import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gameverse/domain/models/payment_method_model/payment_method_model.dart';

part 'publisher_request_model.freezed.dart';
part 'publisher_request_model.g.dart';

@freezed
abstract class PublisherRequestModel with _$PublisherRequestModel {
  const factory PublisherRequestModel({
    @JsonKey(name: 'requestid') required String requestId,
    @JsonKey(name: 'userid') required String userId,
    @JsonKey(name: 'username') required String username,
    @JsonKey(name: 'email') required String email,
    required String description,
    required PaymentMethodModel paymentMethod,
    @JsonKey(name: 'paymentcartnumber') required String paymentCardNumber,
    @JsonKey(name: 'submissiondate') DateTime? submissionDate,
  }) = _PublisherRequestModel;

  factory PublisherRequestModel.fromJson(Map<String, dynamic> json) => 
      _$PublisherRequestModelFromJson(json);
}