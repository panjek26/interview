# Terraform-Parse Service

## Introduction
This service provides an API to convert JSON payloads into Terraform configuration files for AWS S3 bucket creation.

## Setup Instructions
1. **Install Dependencies**:
   ```bash
   pip install -r terraform_parse_service/requirements.txt
   ```

2. **Run the Service**:
   ```bash
   python terraform_parse_service/app.py
   ```

## Usage
- **API Endpoint**: `/parse`
- **Method**: POST
- **Payload**:
  ```json
  {
    "payload": {
      "properties": {
        "aws-region": "eu-west-1",
        "acl": "private",
        "bucket-name": "tripla-bucket"
      }
    }
  }
  ```

- **Response**: Terraform file created successfully.
