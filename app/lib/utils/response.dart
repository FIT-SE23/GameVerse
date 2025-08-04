class Response {
  final int code;
  final String message;
  final dynamic data;

  const Response({required this.code, required this.message, this.data});

  factory Response.fromJson(int statusCode, Map<String, dynamic> body) {
    final code = statusCode;
    final message = body["message"] as String? ?? "";
    final data = body["return"];

    return Response(code: code, message: message, data: data);
  }

  @override
  String toString() {
    String message = this.message.isNotEmpty ? this.message : "\"\"";
    String data =
        this.data.toString().isNotEmpty ? this.data.toString() : "\"\"";
    return "Response {code: $code, message: $message, data: $data}";
  }
}
