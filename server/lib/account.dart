import "package:supabase/supabase.dart";
import "dart:convert";
import "package:crypto/crypto.dart";

final userTableName = "User";

Future<String> addUser(
  SupabaseClient supabase,
  String username,
  String email,
  String password,
) async {
  final bytePassword = utf8.encode(password);
  final hashPassword = sha256.convert(bytePassword).toString();
  try {
    await supabase.from(userTableName).insert({
      "username": "$username",
      "email": "$email",
      "hashpassword": "$hashPassword",
    });
  } on PostgrestException catch (e) {
    PostgrestException exc = e;
    return exc.details.toString();
  }

  return "";
}

Future<String> checkUser(
  SupabaseClient supabase,
  String email,
  String password,
) async {
  final bytePassword = utf8.encode(password);
  final hashPassword = sha256.convert(bytePassword).toString();
  final query = await supabase
      .from(userTableName)
      .select("userid")
      .eq("email", email)
      .eq("hashpassword", hashPassword);
  if (query.length != 1) {
    return "";
  }
  return query[0]["userid"].toString();
}

Future<PostgrestList> listUser(SupabaseClient supabase) async {
  final users = await supabase.from(userTableName).select();
  return users;
}
