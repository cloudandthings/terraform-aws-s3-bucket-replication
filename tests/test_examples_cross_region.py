"""
Test the Terraform code in the tests/terraform/cross_region directory.

Sets up cross-region replication and verifies that
objects copy between regions.
"""

import boto3
import time

import pytest

from tests.conftest import terraform_apply_and_output


@pytest.fixture(scope="module")
def output():
    yield from terraform_apply_and_output(__name__)


def test_s3_replication_creation(output):
    source_bucket_name = output["module_s3_bucket_source"]["bucket"]
    source_bucket_region = output["module_s3_bucket_source"]["region"]
    destination_bucket_name = output["module_s3_bucket_destination"]["bucket"]
    destination_bucket_region = output["module_s3_bucket_destination"]["region"]
    assert source_bucket_region != destination_bucket_region
    time.sleep(10)

    session = boto3.Session()
    s3_src = session.client("s3", region_name=source_bucket_region)
    s3_dest = session.client("s3", region_name=destination_bucket_region)

    key = "test_replication"
    # Write an object to the source bucket
    response = s3_src.put_object(Body=b"bytes", Bucket=source_bucket_name, Key=key)

    # Verify replication status on source object
    iterations = 6 * 10
    source_replication_status = None
    while True:
        time.sleep(10)
        try:
            response = {}
            response = s3_src.get_object(Bucket=source_bucket_name, Key=key)
        except s3_src.exceptions.NoSuchKey:
            pass
        finally:
            source_replication_status = response.get("ReplicationStatus", "NONE")
        print(f"{source_replication_status=}")
        if source_replication_status != "PENDING":
            break
        if iterations <= 0:
            break
        iterations = iterations - 1

    assert "COMPLETED" == source_replication_status

    # Ensure object exists in destination bucket
    time.sleep(10)  # Replication is flaky, give it a few seconds
    response = s3_dest.get_object(Bucket=destination_bucket_name, Key=key)
    destination_replication_status = response.get("ReplicationStatus", "NONE")

    assert "REPLICA" == destination_replication_status
