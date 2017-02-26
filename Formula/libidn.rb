class Libidn < Formula
  desc "International domain name library"
  homepage "https://www.gnu.org/software/libidn/"
  url "https://ftpmirror.gnu.org/libidn/libidn-1.33.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libidn/libidn-1.33.tar.gz"
  sha256 "44a7aab635bb721ceef6beecc4d49dfd19478325e1b47f3196f7d2acc4930e19"

  bottle do
    cellar :any
    rebuild 1
    sha256 "fa848304fc67f59dd8027f7994ef8017607d2e82d11889e5016992749d4b1dab" => :sierra
    sha256 "1dcad8ba66d06c84150b3b6e7078294a03a56b6c419b4561fc83ac0f30d0607d" => :el_capitan
    sha256 "7da1451a42df89e1e0f03a3ede96662d80c407a5dbcb519167ee4be65e79f2e4" => :yosemite
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-csharp",
                          "--with-lispdir=#{elisp}"
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system bin/"idn", "räksmörgås.se", "blåbærgrød.no"
  end
end
