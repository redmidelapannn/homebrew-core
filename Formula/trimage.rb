class Trimage < Formula
  desc "Cross-platform tool for optimizing PNG and JPG files"
  homepage "https://trimage.org"
  url "https://github.com/Kilian/Trimage/archive/1.0.6.tar.gz"
  sha256 "60448b5a827691087a1bd016a68f84d8c457fc29179271f310fe5f9fa21415cf"

  depends_on "advancecomp"
  depends_on "jpegoptim"
  depends_on "optipng"
  depends_on "pngcrush"
  depends_on "pyqt"
  depends_on "python"

  def install
    system "python3", "setup.py", "build"
    system "python3", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    system "#{bin}/trimage", "--help"
  end
end
