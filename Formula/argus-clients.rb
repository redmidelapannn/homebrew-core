class ArgusClients < Formula
  desc "Audit Record Generation and Utilization System clients"
  homepage "https://qosient.com/argus/"
  url "https://qosient.com/argus/src/argus-clients-3.0.8.2.tar.gz"
  sha256 "32073a60ddd56ea8407a4d1b134448ff4bcdba0ee7399160c2f801a0aa913bb1"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "4a34e352e78c2b67a48f5a890891769ce6ba03fcdf381f8b9fb4fbaa294eb3b8" => :high_sierra
    sha256 "952d68bc62e2af74bfe2f1caf72b887525d365ed1276b92cf88d614512845694" => :sierra
    sha256 "ed6e77b3945ff7a95ebedc6f669f90496c84d411049484513dc0db5dc9d0309c" => :el_capitan
  end

  depends_on "readline"
  depends_on "rrdtool"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Ra Version #{version}", shell_output("#{bin}/ra -h", 1)
  end
end
