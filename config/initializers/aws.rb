AWS_ACCESS_KEY_ID        =      ENV['AWS_ACCESS_KEY_ID']
AWS_SECRET_ACCESS_KEY    =      ENV['AWS_SECRET_ACCESS_KEY']
S3_BUCKET_NAME           =      ENV['S3_BUCKET']

Aws.config.update({
  region: 'ap-southeast-1',
  credentials: Aws::Credentials.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY),
})

S3_BUCKET = Aws::S3::Resource.new.bucket(S3_BUCKET_NAME)