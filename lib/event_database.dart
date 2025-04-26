import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:univents_mobile/events.dart';

class EventDatabase {
  final database = Supabase.instance.client.from('events');

  // Create
  // Future createOrganization(Organization newOrganization) async {
  //   await database.insert(newOrganization.toMap());
  // }

  // Read
  final stream = Supabase.instance.client.from('events').stream(
    primaryKey: ['uid'],
  ).map((data) => data.map((eventMap) => Event.fromMap(eventMap)).toList());

  // Update
  // Future updateOrganization(Organization oldOrganization, String newContent) async {
  //   await database.update({'content': newContent}).eq('id', oldOrganization.uuid!);
  // }

  // Delete
  // Future deleteOrganization(Organization organization) async {
  //   await database.delete().eq('id', organization.uuid!);
  // }
}
