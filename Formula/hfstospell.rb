class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.1/hfstospell-0.5.1.tar.gz"
  sha256 "ccf5f3b06bcdc5636365e753b9f7fad9c11dfe483272061700a905b3d65ac750"
  revision 1

  bottle do
    cellar :any
    sha256 "90b9ae13de812cd37ef183ad3f611f7e5086b13179ae0582642f17a9abe597e3" => :catalina
    sha256 "233d4c9007a838d34673d57ba2dde36fb2ddbc6e1fe58da90336d4f1bf29a6c9" => :mojave
    sha256 "22e823afc5f83666a94cb22bd5ebcada52f28ccae98def68ea3abe913dd1fc09" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libarchive"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-libxmlpp",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/hfst-ospell", "--version"
  end
end
