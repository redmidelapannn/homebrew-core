class Squashfs < Formula
  desc "Compressed read-only file system for Linux"
  homepage "http://squashfs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/squashfs/squashfs/squashfs4.3/squashfs4.3.tar.gz"
  sha256 "0d605512437b1eb800b4736791559295ee5f60177e102e4d4ccd0ee241a5f3f6"

  bottle do
    cellar :any
    revision 2
    sha256 "c5ae0a8382713765b2272fd081a7e1364eba5d3bd132c425c7a41c5e9b203d67" => :el_capitan
    sha256 "a40f570140d562fb0d2063194cd057f7a1b0540ec61f2cdc85083e6d6892c98c" => :yosemite
    sha256 "e8f034d5863c4a6f236d6d69d840ce9fed03e3a0cb6dd7c7015ed2e93f65a591" => :mavericks
  end

  depends_on "lzo"
  depends_on "xz"
  depends_on "lz4" => :optional

  # Patch necessary to emulate the sigtimedwait process otherwise we get build failures
  # Also clang fixes, extra endianness knowledge and a bundle of other OS X fixes.
  # Originally from https://github.com/plougher/squashfs-tools/pull/3
  patch do
    url "https://raw.githubusercontent.com/DomT4/scripts/master/Homebrew_Resources/Squashfs/squashfs.diff"
    sha256 "276763d01ec675793ddb0ae293fbe82cbf96235ade0258d767b6a225a84bc75f"
  end

  def install
    args = %W[
      XATTR_SUPPORT=0
      EXTRA_CFLAGS=-std=gnu89
      LZO_SUPPORT=1
      LZO_DIR=#{HOMEBREW_PREFIX}
      XZ_SUPPORT=1
      XZ_DIR=#{HOMEBREW_PREFIX}
    ]
    args << "LZ4_SUPPORT=1" if build.with? "lz4"
    cd "squashfs-tools" do
      system "make", *args
      bin.install %w[mksquashfs unsquashfs]
    end
    doc.install %w[ACKNOWLEDGEMENTS CHANGES COPYING INSTALL OLD-READMEs PERFORMANCE.README README README-4.3]
  end
end
