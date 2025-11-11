import unittest
import re
from app import app

class AppTestCase(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True

    def test_health_check(self):
        response = self.app.get('/health')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json, {"status": "healthy"})

    def test_parse_terraform(self):
        payload = {
            "payload": {
                "properties": {
                    "aws-region": "us-west-2",
                    "bucket-name": "test-bucket",
                    "acl": "public-read",
                    "environment": "prod",
                    "project": "test-project"
                }
            }
        }
        response = self.app.post('/parse', json=payload)
        self.assertEqual(response.status_code, 200)
        content = response.data.decode()
    
        self.assertIn('provider "aws"', content)
        self.assertIn('region = "us-west-2"', content)
        self.assertIn('bucket        = "test-bucket"', content)
        self.assertRegex(content, r'acl\s*=\s*"public-read"')

if __name__ == '__main__':
    unittest.main()
