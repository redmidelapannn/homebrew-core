class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.45.4/e2fsprogs-1.45.4.tar.gz"
  sha256 "e69c69839cf80cb55afa18b9a99ed8f2e559db0313e3d15ac5497ed7e1a34c4b"
  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git"

  bottle do
    sha256 "995530cb13ce296ce391a9f64f29d5fbc1290ded94e04ef18728b1e18602af6c" => :catalina
    sha256 "b6e824bd407190ee1efeddbddef4ef3d8127d622c2efcdab68981f1dcce358f3" => :mojave
    sha256 "c76cf6fe959007b7fe779d79015db036c382c8b8591b73612b3b0dc36c1392f3" => :high_sierra
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
