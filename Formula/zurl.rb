class Zurl < Formula
  desc "HTTP and WebSocket client worker with ZeroMQ interface"
  homepage "https://github.com/fanout/zurl"
  url "https://dl.bintray.com/fanout/source/zurl-1.9.1.tar.bz2"
  sha256 "b57385d768c9df62dd225a462d0e35998f95fdbd34ea628bf3d6a38b012dba41"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9eb5dfcd01ca121fc290334709b9cf40dbc19568f0ceb96095ab93f292407e7f" => :high_sierra
    sha256 "f1b43d4afdc5122bc2e9d5f8a8393b864422a491cdbaee3d1dfac0f707152aa5" => :sierra
    sha256 "8a919b4df5733ac064d69686f0d9ddfdb44434851d6ee1df9c03604d01b726a3" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "python@2" => :test
  depends_on "curl" if MacOS.version < :lion
  depends_on "qt"
  depends_on "zeromq"

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/1e/f9/d0675409c11d11e549e3da000901cfaabd848da117390ee00030e14bfdb6/pyzmq-16.0.3.tar.gz"
    sha256 "8a883824147523c0fe76d247dd58994c1c28ef07f1cc5dde595a4fd1c28f2580"
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

    resource("pyzmq").stage { system "python", *Language::Python.setup_install_args(testpath/"vendor") }

    conffile.write(<<~EOS
      [General]
      in_req_spec=ipc://#{ipcfile}
      defpolicy=allow
      timeout=10
      EOS
                  )

    runfile.write(<<~EOS
      import json
      import threading
      from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
      import zmq
      class TestHandler(BaseHTTPRequestHandler):
        def do_GET(self):
          self.send_response(200)
          self.end_headers()
          self.wfile.write('test response\\n')
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
      sock.send('J' + json.dumps(req))
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
      ENV["PYTHONPATH"] = testpath/"vendor/lib/python2.7/site-packages"
      system "python", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
