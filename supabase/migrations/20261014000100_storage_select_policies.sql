-- Storage needs SELECT on storage.objects to find a file before deleting
-- or overwriting it. Without these, remove() returned 200 with an empty
-- list and replaced opportunity images / avatars were never deleted.
-- Both buckets are public for download already; this only lets the owner
-- (avatars) and admins (opportunity-images) see objects through the API.

create policy "avatars: owner read"
  on storage.objects for select to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );

create policy "opportunity-images: admin read"
  on storage.objects for select to authenticated
  using (bucket_id = 'opportunity-images' and public.is_admin());
