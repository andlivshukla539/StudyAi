import { supabase, DOCUMENTS_BUCKET } from './src/utils/supabase.util';
async function createBucket() {
  const { data, error } = await supabase.storage.createBucket(DOCUMENTS_BUCKET, { public: false });
  if (error) console.error('Error:', error.message);
  else console.log('Bucket created successfully!');
}
createBucket();
