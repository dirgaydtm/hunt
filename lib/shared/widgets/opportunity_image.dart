import 'package:flutter/widgets.dart';

/// Opportunity images are either bundled assets (seed data) or
/// Supabase Storage URLs (uploaded by admins).
ImageProvider opportunityImage(String path) => path.startsWith('http')
    ? NetworkImage(path)
    : AssetImage(path) as ImageProvider;
