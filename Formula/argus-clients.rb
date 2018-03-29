class ArgusClients < Formula
  desc "Audit Record Generation and Utilization System clients"
  homepage "https://qosient.com/argus/"
  url "https://qosient.com/argus/src/argus-clients-3.0.8.2.tar.gz"
  sha256 "32073a60ddd56ea8407a4d1b134448ff4bcdba0ee7399160c2f801a0aa913bb1"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "d0d55ab6574fd025c14598b5a54505e2fe04eab688331bdbf1a23dea4446e24b" => :high_sierra
    sha256 "2bb6410b61d987a851479b9bfca467d09c8668b81e97252b02b2a1e11ffcfb70" => :sierra
    sha256 "c30911236c86a2dad7770d883e64d03ca9cbe182f08b53b5d957f1b9ac1bfee7" => :el_capitan
  end

  depends_on "readline" => :recommended
  depends_on "rrdtool" => :recommended

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
