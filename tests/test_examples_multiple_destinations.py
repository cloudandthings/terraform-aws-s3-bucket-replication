"""
Test the Terraform code in the examples/basic directory.

This test verifies that the example works by executing and testing it.
"""

import pytest
import boto3
import time

from tests.conftest import terraform_apply_and_output


@pytest.fixture(scope="module")
def output():
    yield from terraform_apply_and_output(__name__)


def test_s3_replication_creation(output):
    source_bucket_name = output["module_s3_bucket_source"]["bucket"]
    source_bucket_region = output["module_s3_bucket_source"]["region"]

    session = boto3.Session(region_name=source_bucket_region)
    s3 = session.client("s3")

    key = "test_replication"
    # Write an object to the source bucket
    response = s3.put_object(Body=b"bytes", Bucket=source_bucket_name, Key=key)

    # Verify replication status on source object
    iterations = 6 * 10
    source_replication_status = None
    while True:
        time.sleep(10)
        try:
            response = {}
            response = s3.get_object(Bucket=source_bucket_name, Key=key)
        except s3.exceptions.NoSuchKey:
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

    for destination_bucket in output["module_s3_bucket_destinations"]:
        destination_bucket_name = destination_bucket["bucket"]
        destination_bucket_region = destination_bucket["region"]
        assert source_bucket_region == destination_bucket_region

        response = s3.get_object(Bucket=destination_bucket_name, Key=key)
        destination_replication_status = response.get("ReplicationStatus", "NONE")
        assert "REPLICA" == destination_replication_status
