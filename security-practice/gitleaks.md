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

Why fetch-depth: 0?
Normally GitHub Actions may only retrieve the latest commit.
For security scanning, we also want to inspect Git history:

Current files
+
Previous commits

because deleting a secret from the current file does not necessarily remove it from Git history.