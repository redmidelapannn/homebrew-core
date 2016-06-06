class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "http://mupdf.com"
  url "http://mupdf.com/downloads/archive/mupdf-1.9a-source.tar.gz"
  sha256 "8015c55f4e6dd892d3c50db4f395c1e46660a10b460e2ecd180a497f55bbc4cc"
  head "git://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any
    revision 1
    sha256 "7ef90b7f58164276f38a6fa90324b352960c41bfc19b57b883386add52cf0148" => :el_capitan
    sha256 "2d94022c4922f42bdc64576f5893750c5ee2e0c8c545f305d4a4ac5634073ed0" => :yosemite
    sha256 "d442f5e49898025714b9664ea70304ca433ca07589e360c528915efc81298f34" => :mavericks
  end

  depends_on :macos => :snow_leopard

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    pdf = test_fixtures("test.pdf")
    assert_match "Homebrew test", shell_output("#{bin}/mutool draw -F txt #{pdf}")
  end
end
