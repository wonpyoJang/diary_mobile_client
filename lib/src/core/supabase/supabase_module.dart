// supabase_module.dart
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class SupabaseModule {
  @lazySingleton
  SupabaseClient supabaseClient() {
    return Supabase.instance.client;
  }
}
