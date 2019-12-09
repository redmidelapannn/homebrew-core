class Zurl < Formula
  desc "HTTP and WebSocket client worker with ZeroMQ interface"
  homepage "https://github.com/fanout/zurl"
  url "https://dl.bintray.com/fanout/source/zurl-1.11.0.tar.bz2"
  sha256 "18aa3b077aefdba47cc46c5bca513ca2e20f2564715be743f70e4efa4fdccd7a"

  bottle do
    cellar :any
    rebuild 2
    sha256 "c967dd016d02a53494a97601f72f0f2e66de36c0e7be0e1603aa8765244d2042" => :catalina
    sha256 "b0f11c92513c8181bd70478275ca08ebad7d847a71877b3bf75eb0ddd32e1698" => :mojave
    sha256 "427f4d6d19e8491c4c1b50a42e77c158a0dfc49ac4a618d27d2faa6bf778c8e9" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "python" => :test
  depends_on "qt"
  depends_on "zeromq"
  uses_from_macos "curl"

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/7a/d2/1eb3a994374802b352d4911f3317313a5b4ea786bc830cc5e343dad9b06d/pyzmq-18.1.0.tar.gz"
    sha256 "93f44739db69234c013a16990e43db1aa0af3cf5a4b8b377d028ff24515fbeb3"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--extraconf=QMAKE_MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    conffile = testpath/"zurl.conf"
    ipcfile = testpath/"zurl-req"
    runfile = testpath/"test.py"

    resource("pyzmq").stage { system "python3", *Language::Python.setup_install_args(testpath/"vendor") }

    conffile.write(<<~EOS,
      [General]
      in_req_spec=ipc://#{ipcfile}
      defpolicy=allow
      timeout=10
    EOS
                  )

    runfile.write(<<~EOS,
      import json
      import threading
      from http.server import BaseHTTPRequestHandler, HTTPServer
      import zmq
      class TestHandler(BaseHTTPRequestHandler):
        def do_GET(self):
          self.send_response(200)
          self.end_headers()
          self.wfile.write(b'test response\\n')
      port = None
      def server_worker(c):
        global port
        server = HTTPServer(('', 0), TestHandler)
        port = server.server_address[1]
        c.acquire()
        c.notify()
        c.release()
        try:
          server.serve_forever()
        except:
          server.server_close()
      c = threading.Condition()
      c.acquire()
      server_thread = threading.Thread(target=server_worker, args=(c,))
      server_thread.daemon = True
      server_thread.start()
      c.wait()
      c.release()
      ctx = zmq.Context()
      sock = ctx.socket(zmq.REQ)
      sock.connect('ipc://#{ipcfile}')
      req = {'id': '1', 'method': 'GET', 'uri': 'http://localhost:%d/test' % port}
      sock.send_string('J' + json.dumps(req))
      poller = zmq.Poller()
      poller.register(sock, zmq.POLLIN)
      socks = dict(poller.poll(15000))
      assert(socks.get(sock) == zmq.POLLIN)
      resp = json.loads(sock.recv()[1:])
      assert('type' not in resp)
      assert(resp['body'] == 'test response\\n')
    EOS
                 )

    pid = fork do
      exec "#{bin}/zurl", "--config=#{conffile}"
    end

    begin
      xy = Language::Python.major_minor_version "python3"
      ENV["PYTHONPATH"] = testpath/"vendor/lib/python#{xy}/site-packages"
      system "python3", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
