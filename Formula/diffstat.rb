class Diffstat < Formula
  desc "Produce graph of changes introduced by a diff file"
  homepage "https://invisible-island.net/diffstat/"
  url "https://invisible-mirror.net/archives/diffstat/diffstat-1.61.tgz"
  mirror "https://mirrors.kernel.org/debian/pool/main/d/diffstat/diffstat_1.61.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/diffstat/diffstat_1.61.orig.tar.gz"
  sha256 "25359e0c27183f997b36c9202583b5dc2df390c20e22a92606af4bf7856a55ee"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "19974793a685d9f64ae2ffca414fdecc0c8e76db4d7e81c24eb540a5e5b3814e" => :high_sierra
    sha256 "c4bf0a86b776e4ce0356df3b883d47f51e8c2bc517924e368a8e2b38a67a7b72" => :sierra
    sha256 "a68ad292a5c954b9436a689f1799c287ae35a3d6e1fdeacd5334073efa1d5c6f" => :el_capitan
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
