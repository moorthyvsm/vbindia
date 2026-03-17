import http.server, socketserver, os

DIR = os.path.dirname(os.path.abspath(__file__))
os.chdir(DIR)

PORT = 3456
Handler = http.server.SimpleHTTPRequestHandler
Handler.log_message = lambda *a: None  # silence logs

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Serving at http://localhost:{PORT}")
    httpd.serve_forever()
