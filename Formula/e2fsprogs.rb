class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.45.5/e2fsprogs-1.45.5.tar.gz"
  sha256 "91e72a2f6fee21b89624d8ece5a4b3751a17b28775d32cd048921050b4760ed9"
  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git"

  bottle do
    sha256 "d3dee48ad4e75b444269baa71cee8e7d9e67b5b6f350ef6754d3e8f9700567fb" => :catalina
    sha256 "e74029f73df0ea2f8beb5fe43ab4a37071b49751e5f9b5560062cb1a79df27ad" => :mojave
    sha256 "b05e4895dcbae8bca61960bc2b2fd8e2b54e2cd0f11301131909f961fb010c14" => :high_sierra
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
