-- View: anyone
CREATE POLICY "Anyone can view profile images"
ON storage.objects
FOR SELECT
USING (bucket_id = 'profile-images');

CREATE POLICY "Anyone can upload profile images"
ON storage.objects
FOR INSERT
WITH CHECK (bucket_id = 'profile-images');

CREATE POLICY "Anyone can update profile images"
ON storage.objects
FOR UPDATE
USING (bucket_id = 'profile-images');

CREATE POLICY "Anyone can delete profile images"
ON storage.objects
FOR DELETE
USING (bucket_id = 'profile-images');
