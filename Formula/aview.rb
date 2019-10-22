class Aview < Formula
  desc "ASCII-art image browser and animation viewer"
  homepage "https://aa-project.sourceforge.io/"
  url "https://downloads.sourceforge.net/aa-project/aview-1.3.0rc1.tar.gz"
  sha256 "42d61c4194e8b9b69a881fdde698c83cb27d7eda59e08b300e73aaa34474ec99"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "64ce4989bccb03c4e8f7cb242159c366a6add82142a4b4e72e453de3942cbab4" => :catalina
    sha256 "6a3b04d8156b8343ce1803e1fa3187476a17cf672e0b3c097819e0744e2114ee" => :mojave
    sha256 "3eb439e802c27e8213d140ccb68a6c5ea1a0f3fa855613c8700d130d8cdaa0e3" => :high_sierra
  end

  depends_on "aalib"

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/aview/1.3.0rc1.patch"
    sha256 "72a979eff325056f709cee49f5836a425635bd72078515a5949a812aa68741aa"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/aview", "--version"
  end
end
