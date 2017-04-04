class Diffstat < Formula
  desc "Produce graph of changes introduced by a diff file"
  homepage "http://invisible-island.net/diffstat/"
  url "https://mirrors.kernel.org/debian/pool/main/d/diffstat/diffstat_1.61.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/diffstat/diffstat_1.61.orig.tar.gz"
  sha256 "25359e0c27183f997b36c9202583b5dc2df390c20e22a92606af4bf7856a55ee"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "94b41717aa8766a64988d6a6c9273eb444d0d02478d82ecf396de3f979b708fc" => :sierra
    sha256 "b042eb0869120d4fda1a924d36741de6404a2a02a73a4780b9d95256d0f7e54e" => :el_capitan
    sha256 "b2db4cc70df3b4701f36bd9f8d2e946bf5caff84f64c78e278d59527d6e72b67" => :yosemite
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"diff.diff").write <<-EOS.undent
      diff --git a/diffstat.rb b/diffstat.rb
      index 596be42..5ff14c7 100644
      --- a/diffstat.rb
      +++ b/diffstat.rb
      @@ -2,9 +2,8 @@
      -  url 'https://mirrors.kernel.org/debian/pool/main/d/diffstat/diffstat_1.58.orig.tar.gz'
      -  version '1.58'
      -  sha256 'fad5135199c3b9aea132c5d45874248f4ce0ff35f61abb8d03c3b90258713793'
      +  url 'https://mirrors.kernel.org/debian/pool/main/d/diffstat/diffstat_1.61.orig.tar.gz'
      +  sha256 '25359e0c27183f997b36c9202583b5dc2df390c20e22a92606af4bf7856a55ee'
    EOS
    output = `#{bin}/diffstat diff.diff`
    diff = <<-EOS
 diffstat.rb |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)
    EOS
    assert_equal diff, output
  end
end
