import os
import psycopg
from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/")
def home():
    return """
    <h1>Cloud Security Exercise 3</h1>
    <p>DigitalOcean web service is running.</p>
    """


@app.route("/health")
def health():
    return {"status": "ok"}


@app.route("/items")
def items():
    with psycopg.connect(
        host=os.environ["DB_HOST"],
        port=os.environ["DB_PORT"],
        dbname=os.environ["DB_NAME"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
        sslrootcert=os.environ["DB_SSLROOTCERT"],
        sslmode="verify-full"
    ) as connection:
        with connection.cursor() as cursor:
            cursor.execute("SELECT id, name FROM items ORDER BY id;")
            rows = cursor.fetchall()

    return jsonify([
        {"id": row[0], "name": row[1]}
        for row in rows
    ])


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)