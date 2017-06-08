class Corkscrew < Formula
  desc "Tunnel SSH through HTTP proxies"
  homepage "https://packages.debian.org/sid/corkscrew"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/c/corkscrew/corkscrew_2.0.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/corkscrew/corkscrew_2.0.orig.tar.gz"
  sha256 "0d0fcbb41cba4a81c4ab494459472086f377f9edb78a2e2238ed19b58956b0be"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "826f7ce7a958fc413e0c0313e6447d602a30111f6a1962abfdef130e16bf8662" => :sierra
    sha256 "68b7f2de12242cbc777b6d9c98e2630631a793d5d3fe18aa0af64f2f08dbdc8a" => :el_capitan
    sha256 "0f0c6c2f7466c0bdeaf277e801bc045f4ea41af3c3c21fa72f43fa23bcbcc9c7" => :yosemite
  end

  depends_on "libtool" => :build

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    require "open3"
    require "webrick"
    require "webrick/httpproxy"

    pid = fork do
      proxy = WEBrick::HTTPProxyServer.new :Port => 8080
      proxy.start
    end

    sleep 1

    begin
      Open3.popen3("#{bin}/corkscrew 127.0.0.1 8080 www.google.com 80") do |stdin, stdout, _|
        stdin.write "GET /index.html HTTP/1.1\r\n\r\n"
        assert_match "HTTP/1.1", stdout.gets("\r\n\r\n")
      end
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
