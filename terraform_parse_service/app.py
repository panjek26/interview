from flask import Flask, request, Response, jsonify

app = Flask(__name__)

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy"}), 200


@app.route('/parse', methods=['POST'])
def parse_terraform():
    data = request.json
    properties = data.get('payload', {}).get('properties', {})

    aws_region = properties.get('aws-region', 'us-east-1')
    bucket_name = properties.get('bucket-name', 'default-bucket')
    acl = properties.get('acl', 'private')
    environment = properties.get('environment', 'dev')
    project = properties.get('project', 'tripla')

    terraform_content = f'''# Auto-generated Terraform configuration for AWS S3 Bucket

provider "aws" {{
  region = "{aws_region}"
}}

resource "aws_s3_bucket" "tripla" {{
  bucket        = "{bucket_name}"
  force_destroy = true

  tags = {{
    Environment = "{environment}"
    Project     = "{project}"
  }}
}}

resource "aws_s3_bucket_ownership_controls" "tripla" {{
  bucket = aws_s3_bucket.tripla.id

  rule {{
    object_ownership = "BucketOwnerPreferred"
  }}
}}

resource "aws_s3_bucket_public_access_block" "tripla" {{
  bucket                  = aws_s3_bucket.tripla.id
  block_public_acls        = true
  block_public_policy      = true
  ignore_public_acls       = true
  restrict_public_buckets  = true
}}

resource "aws_s3_bucket_acl" "tripla" {{
  depends_on = [aws_s3_bucket_ownership_controls.tripla]
  bucket     = aws_s3_bucket.tripla.id
  acl        = "{acl}"
}}
'''


    return Response(
        terraform_content,
        mimetype="text/plain",
        headers={
            "Content-Disposition": f"attachment; filename={bucket_name}.tf"
        }
    )


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)
