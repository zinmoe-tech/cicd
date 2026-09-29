Step 1 — Add Gitleaks
vim .github/workflows/ci.yml

then, find current checkout step:
- name: Checkout repository
  uses: actions/checkout@v4

Change it to:
- name: Checkout repository
  uses: actions/checkout@v4
  with:
    fetch-depth: 0

- name: Secret scan with Gitleaks
  uses: gitleaks/gitleaks-action@v2

Why fetch-depth: 0?
Normally GitHub Actions may only retrieve the latest commit.
For security scanning, we also want to inspect Git history:

Current files
+
Previous commits

because deleting a secret from the current file does not necessarily remove it from Git history.

### Gitleaks testing
Step 1 — Create a temporary branch on repo
cd ~/Desktop/cicd-project/cicd

Create:
git checkout -b gitleaks-test

Check:
git branch
git checkout "Brnach name"

Step 2 — Temporarily allow the workflow to run on this branch
Change:
on:
  push:
    branches:
      - main

To this :
on:
  push:
    branches:
      - main
      - gitleaks-test
Reason: otherwise pushing the test branch will not start GitHub Actions.

Step 3 — Create a fake secret file
Create:
vim gitleaks-test.txt

Put this value:
github_token = "ghp_0123456789abcdefghijklmnopqrstuvwxyz"

