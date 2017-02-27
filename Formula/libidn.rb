class Libidn < Formula
  desc "International domain name library"
  homepage "https://www.gnu.org/software/libidn/"
  url "https://ftpmirror.gnu.org/libidn/libidn-1.33.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libidn/libidn-1.33.tar.gz"
  sha256 "44a7aab635bb721ceef6beecc4d49dfd19478325e1b47f3196f7d2acc4930e19"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e59606e584403773b5de96bb5a7de97b265a025593d9e8e1ccc95e71a547cb91" => :sierra
    sha256 "ba9de2062786f7273bd709b3d830e53c9700d072dfc6a360b1ece9f12a78e5b7" => :el_capitan
    sha256 "6d3edd20e6269e03bc27b0a36ef01c431c6b76d9ca1e9eddfe4b7b18ed7da960" => :yosemite
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
