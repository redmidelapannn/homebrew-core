class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.2.tar.gz"
  sha256 "cb20d3a33e07a3b45a49a358b044f4998f452ef9d1a8a5cbde476b6ab9e9b526"

  bottle do
    cellar :any
    rebuild 1
    sha256 "fa8724bba2ffb78c0672509a81a18a542b7b8411f54520e68b1763c354c8d65a" => :sierra
    sha256 "bc3ad1054afbaa95061993420eb239bf2f3b21972ee7d6306191aa523b6fb6ad" => :el_capitan
    sha256 "36f3bea148e6a7618e5d0bd517182ff3430cd3678319ac23fb5630f9a370e06a" => :yosemite
  end

  head do
    url "https://github.com/esnet/iperf.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "openssl"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "clean" # there are pre-compiled files in the tarball
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
