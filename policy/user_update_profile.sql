CREATE POLICY "Anyone can view profile images"
ON storage.objects
FOR SELECT
USING (bucket_id = 'profile-images');

CREATE POLICY "Anyone can upload profile images"
ON storage.objects
FOR INSERT
WITH CHECK (bucket_id = 'profile-images');

CREATE POLICY "Users can update own profile images"
ON storage.objects
FOR UPDATE
USING (
  bucket_id = 'profile-images' 
  AND auth.uid() IS NOT NULL
  AND name LIKE '%' || auth.uid()::text || '%'
);

CREATE POLICY "Users can delete own profile images"
ON storage.objects
FOR DELETE
USING (
  bucket_id = 'profile-images' 
  AND auth.uid() IS NOT NULL
  AND name LIKE '%' || auth.uid()::text || '%'
);