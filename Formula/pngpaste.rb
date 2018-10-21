class Pngpaste < Formula
  desc "Paste PNG into files"
  homepage "https://github.com/jcsalterego/pngpaste"
  url "https://github.com/jcsalterego/pngpaste/archive/0.2.2.tar.gz"
  sha256 "f7566b4eba94916df5723cdcef8e325ee7151c530eec025e996d0e784293362c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a5ae171134159b471a2993934f825f8508cb7d10cab9c5cf16946461f84aa313" => :mojave
    sha256 "ba8d1ada50900485f44b20cb51fb259c3211d6236e2761cf8e4875a597bcca20" => :high_sierra
    sha256 "7ffc4d73a79966ebd9097c2c1e94ff12f86eed478fccb0fef3349cb3eee059d6" => :sierra
  end

  # Sierra's CLT is sufficient, but El Capitain's isn't
  depends_on :xcode => ["8.0", :build] if MacOS.version < :sierra

  depends_on :macos => :el_capitan # needs NSBitmapImageFileTypePNG, etc.

  def install
    system "make", "all"
    bin.install "pngpaste"
  end

  test do
    png = test_fixtures("test.png")
    system "osascript", "-e", "set the clipboard to POSIX file (\"#{png}\")"
    system bin/"pngpaste", "test.png"
    assert_predicate testpath/"test.png", :exist?
  end
end
