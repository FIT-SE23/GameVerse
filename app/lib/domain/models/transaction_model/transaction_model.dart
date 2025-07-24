import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';

part 'transaction_model.g.dart';

@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required String senderId,
    required String receiverId,
    required double amount,
    required DateTime transactionDate,
    required String status,
    String? description,    
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, Object?> json) => 
    _$TransactionModelFromJson(json);
}