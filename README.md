![Tests](https://github.com/martialonline/workflow-status/workflows/Tests/badge.svg)
## Workflow Status Action

Use this action to trigger events such as notifications or alerts at the end of the workflow. This makes it possible to send catch-all notifications.

### Outputs

* `status` - Returns either `success` or `failed`.

### Example usage

Simply add an additional job to the end of the workflow and list the job dependencies within `needs`. Then add a step within that job including a condition to trigger an even like a Slack notification or similar.

```yaml
...
  notification:
    name: Notify
    runs-on: ubuntu-18.04
    needs: [build]
    if: always()
    steps: 
      - uses: martialonline/workflow-status@v1
        id: check
      - run: echo "Some steps have failed, trigger alert"
        if: contains(steps.check.outputs.status, 'failed')
```

### Full Example

```yaml
name: Full Example

on:
  push:
    branches:
      - master

jobs:

  build:
    name: Build
    runs-on: ubuntu-18.04
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v2
      - name: Build
        run: docker build -t example:latest .

  notification:
    name: Notify
    runs-on: ubuntu-18.04
    needs: [build]
    if: always()
    steps: 
      - uses: martialonline/workflow-status@v1
        id: check
      - run: echo "Some steps have failed, trigger alert"
        if: contains(steps.check.outputs.status, 'failed')
```

### License
The Dockerfile and associated scripts and documentation in this project are released under the [MIT](license).