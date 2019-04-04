class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.1/hfstospell-0.5.1.tar.gz"
  sha256 "ccf5f3b06bcdc5636365e753b9f7fad9c11dfe483272061700a905b3d65ac750"

  bottle do
    cellar :any
    sha256 "d185171ef48d1f6b26db201c6e1ad899418c2b2e5568353442d02789316ea182" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libarchive"
  depends_on "libxml++"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/hfst-ospell", "--version"
  end
end
