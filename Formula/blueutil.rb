class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/v1.1.2.tar.gz"
  sha256 "cd23f389c5366584a5cf5679224da8811c17a6862282220abe28f7c91d3ed0cc"

  head "https://github.com/toy/blueutil.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "47f0d22c617abf6d8061c47a46ea734baafbc3721b4197fae96a11a0f7837d1a" => :sierra
    sha256 "07d03171b4ef9456cb65671714cd1700a1a42bfbf88bb48843a80e0796bab6eb" => :el_capitan
    sha256 "d605b50a9c84e8501e4f59b0dc5156a3ab39217541696e48d8b809ced0ed8ee7" => :yosemite
  end

  def install
    bin.mkpath
    inreplace "Makefile",
      "@echo $(INSTALL_PROGRAM) blueutil $(DESTDIR)$(bindir)/blueutil",
             "$(INSTALL_PROGRAM) blueutil #{bin}/blueutil"
    system "make", "install"
  end

  test do
    system "#{bin}/blueutil"
  end
end
