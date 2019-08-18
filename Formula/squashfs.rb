class Squashfs < Formula
  desc "Compressed read-only file system for Linux"
  homepage "https://squashfs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/squashfs/squashfs/squashfs4.3/squashfs4.3.tar.gz"
  sha256 "0d605512437b1eb800b4736791559295ee5f60177e102e4d4ccd0ee241a5f3f6"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "595a65e690ae1c57a18b420696182236bdc2b8f13943e796b05cd5e87169331a" => :mojave
    sha256 "26c581fb533d46fcb6ed397f7d5c6e0ea3721fa94952eea29449849b4ea9f004" => :high_sierra
    sha256 "95bb9d618f4c3a4929eebbb4a166114347f6bd9a578d6096fd8e76fcb9a116e7" => :sierra
  end

  depends_on "lz4"
  depends_on "lzo"
  depends_on "xz"
  depends_on "zstd"

  # Patch necessary to emulate the sigtimedwait process otherwise we get build failures
  # Also clang fixes, extra endianness knowledge and a bundle of other macOS fixes.
  # Originally from https://github.com/plougher/squashfs-tools/pull/3
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/05ae0eb1/squashfs/squashfs-osx-bundle.diff"
    sha256 "276763d01ec675793ddb0ae293fbe82cbf96235ade0258d767b6a225a84bc75f"
  end

  # ZSTd support
  patch do
    url "https://raw.githubusercontent.com/lunatic-cat/homebrew-tap/680daa95f7d52736314dee3cfceae7e094f7befa/patches/0006-squashfs-tools-Add-zstd-support.patch"
    sha256 "2fe7958af8e51aa27dac89c4a24e76a738634c11166362c65c43fe7e2cacecce"
  end

  def install
    args = %W[
      EXTRA_CFLAGS=-std=gnu89
      ZSTD_SUPPORT=1
      LZ4_SUPPORT=1
      LZMA_XZ_SUPPORT=1
      LZO_DIR=#{Formula["lzo"].opt_prefix}
      LZO_SUPPORT=1
      XATTR_SUPPORT=0
      XZ_DIR=#{Formula["xz"].opt_prefix}
      XZ_SUPPORT=1
    ]

    cd "squashfs-tools" do
      system "make", *args
      bin.install %w[mksquashfs unsquashfs]
    end
    doc.install %w[ACKNOWLEDGEMENTS INSTALL OLD-READMEs PERFORMANCE.README README-4.3]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unsquashfs -v", 1)
  end
end
