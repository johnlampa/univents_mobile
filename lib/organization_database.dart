import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:univents_mobile/organization.dart';

class OrganizationDatabase {
  final database = Supabase.instance.client.from('organizations');

  // Create
  // Future createOrganization(Organization newOrganization) async {
  //   await database.insert(newOrganization.toMap());
  // }

  // Read
  final stream = Supabase.instance.client.from('organizations').stream(
    primaryKey: ['uid'],
  ).map((data) => data.map((organizationMap) => Organization.fromMap(organizationMap)).toList());

  // Update
  // Future updateOrganization(Organization oldOrganization, String newContent) async {
  //   await database.update({'content': newContent}).eq('id', oldOrganization.uuid!);
  // }

  // Delete
  // Future deleteOrganization(Organization organization) async {
  //   await database.delete().eq('id', organization.uuid!);
  // }
}
