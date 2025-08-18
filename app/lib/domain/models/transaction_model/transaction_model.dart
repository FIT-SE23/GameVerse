import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';

part 'transaction_model.g.dart';

@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    @JsonKey(name: 'transactionid') String? transactionId,
    @JsonKey(name: 'senderid') required String senderId,
    @JsonKey(name: 'gameid') required String gameId,
    @JsonKey(name: 'moneyamount') required double moneyAmount,
    @JsonKey(name: 'transactiondate') required DateTime transactionDate,
    @JsonKey(name: 'isrefundable') required bool isRefundable,
    @JsonKey(name: 'paymentmethodid') required String paymentMethodId,

    @Default('completed') String? status,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, Object?> json) => 
    _$TransactionModelFromJson(json);
}