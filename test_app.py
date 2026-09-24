from app import app


def test_home():
    client = app.test_client()
    response = client.get("/")

    assert response.status_code == 200
    assert b"Hello from Zin Moe CI/CD Project!" in response.data


def test_health():
    client = app.test_client()
    response = client.get("/health")

    assert response.status_code == 200