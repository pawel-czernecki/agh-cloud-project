import json
import os

import boto3
from aws_secretsmanager_caching import SecretCache, SecretCacheConfig

REGION = "us-east-1"
CACHE_CONFIG = SecretCacheConfig()
SECRET_ID = os.environ["SECRET_ID"]

aws_client = boto3.client("secretsmanager", region_name=REGION)
sm = SecretCache(config=CACHE_CONFIG, client=aws_client)

def get_db_creds() -> dict:
    return json.loads(sm.get_secret_string(SECRET_ID))
