package python

// # What
// pythonのgithub actionsの環境構築を簡潔にするため
// 
name: "Base Workflow"
on: {
	workflow_call:

		push: branches: [
			"develop",
		]
}

jobs: build: {
	"runs-on": "ubuntu-latest"
	strategy: matrix: {
		os: ["ubuntu-latest", "macos-latest", "windows-latest"]
		"python-version": #PythonVersions & ["3.8", "3.9"]
	}

	steps: [{
		uses: "actions/checkout@v3"
	}, {
		name: "setup python ${{ matrix.python-version }}"
		uses: "actions/setup-python@v4"
		with: {
			"python-version": "${{ matrix.python-version }}"
			architecture:     "x64"
		}
	}, {
		name:  "dependencies"
		shell: "bash"
		run: """
			pushd './${{ env.AZURE_FUNCTIONAPP_PACKAGE_PATH }}'
			python -m pip install --upgrade pip
			pip install flake8 pytest
			pip install -r requirements.txt --target=\".python_packages/lib/site-packages\"
			popd

			"""
	}, {
		name: "Test with pytest"
		run:  "pytest"
	}]
}
