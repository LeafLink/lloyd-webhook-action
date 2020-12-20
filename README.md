# LLoyd Webhook Caller

Used by LeafLink repositories to call LLoyd webhooks when events occur within a GitHub Action workflow

---

[![Current Release](https://img.shields.io/badge/release-0.1.0-1eb0fc.svg)](https://github.com/leaflink/lloyd-webhook-action/releases/tag/0.1.0)

## Description

This action is used to call a webhook within the LLoyd Slackbot whenever an event it needs to know about occurs within a GitHub Action workflow.

## Configuration

| Option Name | Required | Description | Default |
| ----------- | -------- | ----------- | ------- |
| `webhook_url` | `Yes` | The webhook URL to call | N/A |
| `webhook_token` | `Yes` | The authentication token for the webhook | N/A |
| `event` | `Yes` | The type of event that has occurred | N/A |
| `repo` | `No` | The name of the GitHub repository the Action is being run from | `invalid` |
| `tag` | `No` | The git tag corresponding to the Action run | `invalid` |

### A note about `repo` and `tag`

If you do not specify the repo or tag, this action will attempt to determine their values based on environment variables. Typically you can omit these values and let the action do the work for you.

For `repo`, the action will use the `GITHUB_REPOSITORY` environment variable to determine the repository.

For `tag`, the action will use the `RELEASE_TAG` environment variable to determine the release tag. **NOTE**: the `RELEASE_TAG` environment variable is a LeafLink workflow construct, not a default variable GitHub provides. It's value is equivalent to `${{ github.event.release.tag_name }}`.

For more information on environment variables and the GitHub context, see [here](https://docs.github.com/en/free-pro-team@latest/actions/reference/environment-variables) and [here](https://docs.github.com/en/free-pro-team@latest/actions/reference/context-and-expression-syntax-for-github-actions).

## Usage

To use this plugin in a GitHub Action job, add the following step:

```yaml
- name: Notify LLoyd
  uses: leaflink/lloyd-webhook-action@<semver>
  with:
    webhook_url: https://leaflink.com/path/to/webhook
    webhook_token: ${{ secrets.LLOYD_WEBHOOK_TOKEN }}
    event: build_started|tag_pushed
```

*NOTE*: make sure to replace `<semver>` above with the correct semver-tagged release you need to use. Typically this is the most recent release, which can be found in the [/releases](/releases) section.
