class Lowdown < Formula
  desc "Markdown translator with a troff(1) backend"
  homepage "https://kristaps.bsd.lv/lowdown/"
  url "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-0.1.9.tar.gz"
  sha256 "3b809f9cb4cf6912bb2f70666cdf186d2553f1abfd549ab537b782b4688c4e71"

  bottle do
    cellar :any_skip_relocation
    sha256 "72f462a53cbf3a32faca5f543e5229f86ae401f0fc3557d33b90cc45bce1954a" => :sierra
    sha256 "63aaa534c6abaa2a9aa539e24129d171140e6bf0c2d503ca58aaa42fffef4e5e" => :el_capitan
    sha256 "a7da2956968e042bd7adb3224b3af29dac2e77a8e65b479d095d6b883e041720" => :yosemite
  end

  def install
    (buildpath/"configure.local").write <<-CFG.undent
      PREFIX=#{prefix}
      INCLUDEDIR=#{include}
      BINDIR=#{bin}
      LIBDIR=#{lib}
      MANDIR=#{man}
    CFG
    system "./configure"
    system "make", "install"
  end

  test do
    (testpath/"test.md").write("# Hello, **world**")
    system bin/"lowdown"
  end
end
