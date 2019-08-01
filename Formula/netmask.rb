class Netmask < Formula
  desc "IP address formatting tool"
  homepage "https://github.com/tlby/netmask"
  url "https://github.com/tlby/netmask/archive/v2.4.4.tar.gz"
  sha256 "7e4801029a1db868cfb98661bcfdf2152e49d436d41f8748f124d1f4a3409d83"

  bottle do
    cellar :any_skip_relocation
    sha256 "44851986d1ec207519e85eb3a193520eb7efcbdb75567ee1d7d8742ba3d46ebd" => :mojave
    sha256 "801e9ffc70c654871621bbccbe6cb37a61a010102b3b64d4d9fca11b643363fa" => :high_sierra
    sha256 "0ebdf153bee4f1f390107f88d75c704adc302369493f67b7160c7eee9ad47022" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "10.0.0.0/23", shell_output("#{bin}/netmask 10.0.0.0:10.0.1.255").strip
  end
end
