Why did we declare like below in github action workflow?

      - name: Run automated tests
        run: pytest

instead of 
- name: Run automated tests
  run: pytest test_app.py

The answer is because it runs all tests in the project. Later, if you add more files like:
test_api.py
test_database.py
test_user.py

Why did we use ${{ github.sha }} in version tag?
- name: Build Docker image
  run: docker build -t cicd-python-app:${{ github.sha }} .

${{ github.sha }} is a GitHub Actions variable containing the commit SHA.
So instead of always building: cicd-python-app:v1
GitHub builds something like: cicd-python-app:a9d4908...
