name: "deploy website"
on: {
	workflow_dispatch: {
		inputs: ref: {
			description: "branch|tag|SHA to checkout"
			default:     "master"
			required:    true
		}
	}
}
jobs:
	deploy: {
		"runs-on":
			"ubuntu-latest"
		steps: [{
			uses: "actions/checkout@v2"
			with: ref: "${{ github.event.inputs.ref }}"
		}, {
			uses: "actions/setup-node@v2"

			with: "node-version":
				"^16.10.0"
		}, {
			name: "Build", shell: "bash"
			run: """
				yarn install
				yarn run build

				"""
		}, {
			name: "Run Jest Test"
			run:  "yarn run test"
		}, {
			uses:
				"amondnet/vercel-action@v20"
			with: {
				"vercel-token":
						"${{ secrets.VERCEL_TOKEN }}"
				"vercel-args": "--prod" // Optional
				"vercel-org-id":
							"${{ secrets.ORG_ID}}" //Required
				"vercel-project-id": "${{ secrets.PROJECT_ID}}"
				//Required
				"working-directory": "./"
			}
		}]
	}
