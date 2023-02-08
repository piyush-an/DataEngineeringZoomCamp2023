from prefect.deployments import Deployment
from etl_web_to_gcs import etl_web_to_gcs_parent
from prefect.filesystems import GitHub 

storage = GitHub.load("github-de-02wf")

deployment = Deployment.build_from_flow(
     flow=etl_web_to_gcs_parent,
     name="etl_web_to_gcs_parent-git",
     storage=storage,
     entrypoint="2_wf_orch/flows/etl_web_to_gcs.py:etl_web_to_gcs_parent")

if __name__ == "__main__":
    deployment.apply()