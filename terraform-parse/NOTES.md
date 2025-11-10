# Notes

## API Service Creation
The backend service is built using Flask. It receives a JSON payload and generates a Terraform file for an S3 bucket.

## Terraform Fixes
- Parameterized the S3 bucket name and ACL.
- Improved modularity for multi-environment support.

## Helm Fixes
- Updated backend deployment to use the Flask app image.
- Corrected frontend service selector.

## Multi-Environment Thoughts
Consider using Terraform workspaces or separate variable files for different environments.

## AI Usage
AI was used to assist in code refactoring and documentation.