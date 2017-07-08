class Iperf < Formula
  desc "Tool to measure maximum TCP and UDP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.2.tar.gz"
  sha256 "cb20d3a33e07a3b45a49a358b044f4998f452ef9d1a8a5cbde476b6ab9e9b526"

  bottle do
    cellar :any
    sha256 "4d65236ce71e541a9df28a43beda54b4a633a7743a2a9fe60d79f5d040315e17" => :sierra
    sha256 "bc71a4cf7802a401c81a7fbd9dc1dc1f98076a88afc997ce029adae7ce6ff4d5" => :el_capitan
    sha256 "6d4e97e25c2f7342dbb2c3ac63af0559bb6638ad537ed71ac238cb80cfe81b7a" => :yosemite
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
           "--prefix=#{prefix}",
           "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    begin
      server = IO.popen("#{bin}/iperf3 --server")
      sleep 1
      assert_match "Bitrate", pipe_output("#{bin}/iperf3 --client 127.0.0.1 --time 1")
    ensure
      Process.kill("SIGINT", server.pid)
      Process.wait(server.pid)
    end
  end
end
