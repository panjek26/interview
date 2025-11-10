# Terraform Parse Service

This service provides an API to automatically generate Terraform S3 bucket files based on a JSON payload.

---

## Service Access

- Base URL: `http://34.50.76.209`
- Health check: `GET api/health`
- Terraform parsing: `POST /api/parse`

---

## API Endpoints

### 1. Health Check

```bash
curl http://34.50.76.209/api/health
```

**Response:**

```json
{
  "status": "healthy"
}
```

---

### 2. Parse Terraform

```bash
curl -k -X POST http://34.50.76.209/api/parse \
-H "Content-Type: application/json" \
-d '{
  "payload": {
    "properties": {
      "aws-region": "eu-west-1",
      "acl": "private",
      "bucket-name": "tripla-bucket",
      "environment": "prod",
      "project": "test-project"
    }
  }
}' -o bucket.tf
```

- This will generate a `bucket.tf` file with the Terraform configuration for the specified S3 bucket.

---

## Running Locally

1. Clone the repository:

```bash
git clone https://github.com/panjek26/interview.git
cd interview/terraform_parse_service
```

2. Install Python dependencies:

```bash
python -m pip install --upgrade pip
pip install -r requirements.txt
```

3. Run the service:

```bash
python app.py
```

- The service will start on `http://0.0.0.0:5001`.

---

## Running Tests Locally

```bash
python -m unittest discover terraform_parse_service
```

- This will run the unit tests including health check and Terraform parsing.

---

## Building Docker Image Locally

1. Backend:

```bash
docker build -t <docker-username>/be-terraform-parse-service:latest -f Dockerfile .
```

2. Frontend (if applicable):

```bash
docker build -t <docker-username>/fe-terraform-parse:latest -f Dockerfile.frontend .
```

3. Run locally:

```bash
docker run -p 5001:5001 <docker-username>/be-terraform-parse-service:latest
```

---

## GitHub Actions CI/CD

The repository includes a workflow in `.github/workflows/ci-cd.yaml` that:

1. Runs unit tests.
2. Logs in to Docker Hub using secrets (`DOCKER_USERNAME` and `DOCKER_ACCESS_TOKEN`).
3. Builds and pushes the backend and frontend Docker images.

### Key Steps in Workflow

- **Test Job:**

```yaml
python -m unittest discover terraform_parse_service
```

- **Build and Push Job:**

```yaml
docker build -t $DOCKER_USERNAME/be-terraform-parse-service:latest -f terraform_parse_service/Dockerfile terraform_parse_service
docker build -t $DOCKER_USERNAME/fe-terraform-parse:latest -f terraform_parse_service/Dockerfile.frontend terraform_parse_service
docker push $DOCKER_USERNAME/be-terraform-parse-service:latest
docker push $DOCKER_USERNAME/fe-terraform-parse:latest
```

- Secrets must be configured in GitHub repository:
  - `DOCKER_USERNAME`
  - `DOCKER_ACCESS_TOKEN` (Docker Hub personal access token)

---

## Notes

- Ensure the JSON payload follows the required format, including `aws-region`, `bucket-name`, and optionally `acl`, `environment`, and `project`.
- The generated Terraform file includes S3 bucket resource, ownership controls, public access block, and ACL configuration.
