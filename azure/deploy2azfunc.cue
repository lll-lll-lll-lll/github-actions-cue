package azure

import "github.com/cue_template/schemas/azureSchema"

name: azureSchema.#WorkfowName

on: {
	workflow_dispatch: inputs: ref:
	{
		description: "branch|tag|SHA to checkout"
		default:     "master"
		require:     true
	}
	push: branches: [
		"master",
	]
}

env: {
	AZURE_FUNCTIONAPP_PACKAGE_PATH: "."
	AZURE_FUNCTIONAPP_NAME:         azureSchema.#AzureFuncName & "sample-python-githubactions"
	PYTHON_VERSION:                 azureSchema.#PythonVersion & "3.9"
}

jobs: {
	callbaseworkflow: {
		uses: "./.github/workflows/base.yml"
	}
	deploy_from_base: {
		"runs-on":   "ubuntu-latest"
		environment: "production"
		steps: [
			{
				name: "Run Azure Functions Action"
				uses: "Azure/functions-action@v1"
				id:   "fa"
				with: {
					"app-name":        "${{ env.AZURE_FUNCTIONAPP_NAME }}"
					"package":         "${{ env.AZURE_FUNCTIONAPP_PACKAGE_PATH }}"
					"publish-profile": "${{ secrets.AZURE_FUNCTIONAPP_PUBLISH_PROFILE }}"
				}
			},
		]
	}
}
