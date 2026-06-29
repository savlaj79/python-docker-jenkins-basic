from flask import Flask
#Comment
app = Flask(__name__)

@app.route('/')
def hello():
    return {'message': 'Hello from Python Docker!', 'status': 'success'}

@app.route('/health')
def health():
    return {'status': 'healthy'}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
