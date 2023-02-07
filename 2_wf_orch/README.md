# Workflow Orchestration

[Prefect](https://www.prefect.io/) is a modern workflow orchestration tool for coordinating all of your data tools. Orchestrate and observe your dataflow using Prefect's open source Python library, the glue of the modern data stack. Scheduling, executing and visualizing your data workflows has never been easier.

## Activities

Code Snippits

```bash
# Install package
pip install prefect==2.7.7

# Run prefect server
prefect orion start

# Create a deployment 
prefect deployment build .\flows\file_name.py:flow_name -n "deployment-name"

# Apply the deployment
prefect deployment apply .\deployment-name-deployment.yaml

# Create Work Queues
prefect agent start  --work-queue "default"
```


