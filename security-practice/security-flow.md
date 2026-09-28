Developer push
   ↓
Code checkout
   ↓
Unit tests
   ↓
Security checks
   ├── dependency scan
   ├── secret scan
   ├── source/code scan
   └── container image scan
   ↓
Policy decision
   ↓
PASS → push/deploy
FAIL → stop pipeline


Secret scanning — stop AWS keys, passwords, tokens, private keys from entering Git.
Dependency scanning — detect vulnerable Python packages.
Container image scanning — detect OS/package vulnerabilities in the Docker image.
Static code scanning — basic security analysis of Python code.
Policy gate — fail the pipeline on severity thresholds.
Later: admission policy in Kubernetes using Kyverno or OPA Gatekeeper.