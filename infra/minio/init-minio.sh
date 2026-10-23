#!/bin/sh
set -eu

mc alias set local http://minio:9000 "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD"
mc mb --ignore-existing local/datasets
mc mb --ignore-existing local/student-results
mc cp /sample.csv local/datasets/sample.csv

if ! mc admin user info local "$MINIO_STUDENT_ACCESS_KEY" >/dev/null 2>&1; then
  mc admin user add local "$MINIO_STUDENT_ACCESS_KEY" "$MINIO_STUDENT_SECRET_KEY"
fi

cat >/tmp/student-policy.json <<'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetBucketLocation", "s3:ListBucket"],
      "Resource": ["arn:aws:s3:::datasets", "arn:aws:s3:::student-results"]
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
      "Resource": ["arn:aws:s3:::datasets/*", "arn:aws:s3:::student-results/*"]
    }
  ]
}
EOF

mc admin policy create local student-policy /tmp/student-policy.json 2>/dev/null || true
mc admin policy attach local student-policy --user "$MINIO_STUDENT_ACCESS_KEY"
printf '%s\n' 'MinIO buckets and student policy are ready.'
