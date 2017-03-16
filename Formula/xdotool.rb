class Xdotool < Formula
  desc "Fake keyboard/mouse input and window management for X"
  homepage "https://www.semicomplete.com/projects/xdotool/"
  url "https://github.com/jordansissel/xdotool/archive/v3.20160805.1.tar.gz"
  sha256 "ddafca1239075c203769c17a5a184587731e56fbe0438c09d08f8af1704e117a"

  bottle do
    rebuild 1
    sha256 "449293addbdc5bfb8c8cccde4a6d94dc6f112cdf0bd7ca5d5717165ceef614be" => :sierra
    sha256 "6b58054e77b399c9087938407cdbd34ad2be5003cbeafa8f5efaa4a6c5ecf47c" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libxkbcommon"

  depends_on :x11

  def install
    system "make", "PREFIX=#{prefix}", "INSTALLMAN=#{man}", "install"
  end

  def caveats; <<-EOS.undent
    You will probably want to enable XTEST in your X11 server now by running:
      defaults write org.x.X11 enable_test_extensions -boolean true

    For the source of this useful hint:
      https://stackoverflow.com/questions/1264210/does-mac-x11-have-the-xtest-extension
    EOS
  end

  test do
    system "#{bin}/xdotool", "--version"
  end
end
