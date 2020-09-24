![Tests](https://github.com/martialonline/workflow-status/workflows/Tests/badge.svg)
## Workflow Status Action

Use this action to trigger events such as notifications or alerts at the end of your workflow. This makes it possible to send catch-all notifications.

### Outputs

* `status` - Returns either `success`, `cancelled` or `failure`.

### Example usage

Simply add a job to the end of your workflow and list the last job as dependency using `needs`. Then add a step within that job including a condition to trigger an event like a Slack notification or similar.

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
      - run: echo "Workflow failed"
        if: steps.check.outputs.status == 'failure'
      - run: echo "Workflow was cancelled"
        if: steps.check.outputs.status == 'cancelled'
      - run: echo "Workflow was successful"
        if: steps.check.outputs.status == 'success'
```

### Full Example (Slack Notification)

This is a full example using the Workflow Status Action to trigger a Slack notification at the end of the run. The condition is optional, which in this case triggers a Slack nofication for either `success`, `failure` or `cancelled` status.

```yaml
name: Slack Example

on:
  push:
    branches:
      - master

jobs:

  test:
    name: Test
    runs-on: ubuntu-18.04
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v2
      - name: Unit Tests
        run: go test ./...

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
      - uses: 8398a7/action-slack@v3
        with:
          status: ${{ steps.check.outputs.status }}
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

### License
The Dockerfile and associated scripts and documentation in this project are released under the [MIT](license).