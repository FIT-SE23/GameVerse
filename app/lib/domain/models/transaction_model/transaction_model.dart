import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';

part 'transaction_model.g.dart';

@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    @JsonKey(name: 'transactionid') required String transactionId,
    @JsonKey(name: 'senderid') required String senderId,
    @JsonKey(name: 'gameid') required String gameId,
    required double amount,
    @JsonKey(name: 'transactiondate') required DateTime transactionDate,
    required String status,
    @JsonKey(name: 'isRefundable') required bool isRefundable,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, Object?> json) => 
    _$TransactionModelFromJson(json);
}