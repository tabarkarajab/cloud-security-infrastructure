from flask import Flask

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


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)