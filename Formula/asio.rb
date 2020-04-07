class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.14.0%20%28Stable%29/asio-1.14.0.tar.bz2"
  sha256 "2e1be1a518a568525f79b5734d13731b6b4e4399ec576a0961db6e2d86112973"
  head "https://github.com/chriskohlhoff/asio.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7f7b7e00dda7c52ade5bde377352442ab5fc38aac959bc2ef106ac64e8df00a0" => :catalina
    sha256 "83b10bc12fc8edc3264f7daddb66dbc9a78fad68ea7219d92a79e08bdd841592" => :mojave
    sha256 "fcf968db4b6be44343b61f89deffc2719199d1b4f6fa43b03823ae7fec39fe48" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl@1.1"

  def install
    ENV.cxx11

    if build.head?
      cd "asio"
      system "./autogen.sh"
    else
      system "autoconf"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost=no"
    system "make", "install"
    pkgshare.install "src/examples"
  end

  test do
    found = Dir[pkgshare/"examples/cpp{11,03}/http/server/http_server"]
    raise "no http_server example file found" if found.empty?

    port = free_port
    pid = fork do
      exec found.first, "127.0.0.1", port.to_s, "."
    end
    sleep 1
    begin
      assert_match /404 Not Found/, shell_output("curl http://127.0.0.1:#{port}")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
