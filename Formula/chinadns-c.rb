class ChinadnsC < Formula
  desc "Port of ChinaDNS to C: fix irregularities with DNS in China"
  homepage "https://github.com/shadowsocks/ChinaDNS"
  url "https://github.com/shadowsocks/ChinaDNS/releases/download/1.3.2/chinadns-1.3.2.tar.gz"
  sha256 "abfd433e98ac0f31b8a4bd725d369795181b0b6e8d1b29142f1bb3b73bbc7230"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2f5a031d76be80d2a24cf15ec380288217588306719c32a67a04444146641597" => :mojave
    sha256 "f1e385dff1cbc66a09edf6dd05d220c975fc44f9fe7f5c5a2020ffbc8a1c3494" => :high_sierra
    sha256 "69307686d4df0dd4ede8934ab60ca7543b71b0437cafc193ac650a6f7a079d2d" => :sierra
  end

  head do
    url "https://github.com/shadowsocks/ChinaDNS.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/chinadns", "-h"
  end
end
