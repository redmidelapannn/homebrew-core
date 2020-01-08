class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.45.5/e2fsprogs-1.45.5.tar.gz"
  sha256 "91e72a2f6fee21b89624d8ece5a4b3751a17b28775d32cd048921050b4760ed9"
  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git"

  bottle do
    sha256 "dbb3ffccb4bc6226a97e286a9cea43bb3bfce651762938024a599cc3d8535eaf" => :catalina
    sha256 "7aa04dd0248a378fd1b068832305c75cef5a7fbbdadb6482a7dc03a9096f9abf" => :mojave
    sha256 "3bdfa972a657c124eb2786f12e2daeaf4ca763bc8ae97171e5f105dcc1e3c046" => :high_sierra
  end

  keg_only "this installs several executables which shadow macOS system commands"

  depends_on "pkg-config" => :build
  depends_on "gettext"

  def install
    # Enforce MKDIR_P to work around a configure bug
    # see https://github.com/Homebrew/homebrew-core/pull/35339
    # and https://sourceforge.net/p/e2fsprogs/discussion/7053/thread/edec6de279/
    system "./configure", "--prefix=#{prefix}", "--disable-e2initrd-helper",
                          "MKDIR_P=mkdir -p"

    system "make"
    system "make", "install"
    system "make", "install-libs"
  end

  test do
    assert_equal 36, shell_output("#{bin}/uuidgen").strip.length
    system bin/"lsattr", "-al"
  end
end
