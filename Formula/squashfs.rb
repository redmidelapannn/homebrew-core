class Squashfs < Formula
  desc "Compressed read-only file system for Linux"
  homepage "http://squashfs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/squashfs/squashfs/squashfs4.3/squashfs4.3.tar.gz"
  sha256 "0d605512437b1eb800b4736791559295ee5f60177e102e4d4ccd0ee241a5f3f6"

  bottle do
    cellar :any
    revision 1
    sha256 "769b85e62fea85488ff0e05915634bcbad67b545862800b563b6198f20a8b72e" => :el_capitan
    sha256 "8d85f58d931af53e6baf4a7aa9a2c8254ffbb738bb6c559853345e7699cbdfef" => :yosemite
    sha256 "c31a330128c85dc7fb8b2bd320f9a0f00469eff571323a6bbde435fa98496104" => :mavericks
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
