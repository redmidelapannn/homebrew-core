class Unit < Formula
  desc "Dynamic web and application server"
  homepage "https://unit.nginx.org"
  url "https://unit.nginx.org/download/unit-1.15.0.tar.gz"
  sha256 "f8b231d02865b5695825a2a77ecbfd0cff33c0954c0d351d2d773d7e5f6237dd"
  head "https://hg.nginx.org/unit", :using => :hg

  bottle do
    sha256 "c59e860a15e09d81137cece6e5e751fb1b94a5ef517a760c1c51a1d2d1fb42c9" => :catalina
    sha256 "dc305ef31e54cd9df6631e8491a5a4154e2af4e06015eaf5d97857aec706d339" => :mojave
    sha256 "486ec455d0cd0a3c96340c0713feea93968e15d9bf583b83eefb9277ab5e5059" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    system "./configure",
              "--prefix=#{prefix}",
              "--sbindir=#{bin}",
              "--log=#{var}/log/unit/unit.log",
              "--pid=#{var}/run/unit/unit.pid",
              "--control=unix:#{var}/run/unit/control.sock",
              "--modules=#{HOMEBREW_PREFIX}/lib/unit/modules",
              "--state=#{var}/state/unit",
              "--openssl",
              "--cc-opt=-I#{Formula["openssl@1.1"].opt_prefix}/include",
              "--ld-opt=-L#{Formula["openssl@1.1"].opt_prefix}/lib"

    system "make"
    system "make", "install", "libunit-install"
  end

  def post_install
    (lib/"unit/modules").mkpath
    (var/"log/unit").mkpath
    (var/"run/unit").mkpath
    (var/"state/unit/certs").mkpath
  end

  test do
    require "socket"

    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    expected_output = "Hello world!"
    (testpath/"index.html").write expected_output
    (testpath/"unit.conf").write <<~EOS
      {
        "routes": [ { "action": { "share": "#{testpath}" } } ],
        "listeners": { "*:#{port}": { "pass": "routes" } }
      }
    EOS

    system bin/"unitd", "--log", "#{testpath}/unit.log",
                        "--control", "unix:#{testpath}/control.sock",
                        "--pid", "#{testpath}/unit.pid",
                        "--state", "#{testpath}/state"
    sleep 3

    pid = File.open(testpath/"unit.pid").gets.chop.to_i

    system "curl", "-s", "--unix-socket", "#{testpath}/control.sock",
                    "-X", "PUT",
                    "-d", "@#{testpath}/unit.conf", "127.0.0.1/config"

    assert_match expected_output, shell_output("curl -s 127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid)
  end
end
