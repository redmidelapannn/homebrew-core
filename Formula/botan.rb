class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"

  stable do
    url "https://botan.randombit.net/releases/Botan-1.10.12.tgz"
    sha256 "affc3a79919577943f896e64d3e4a4dcc4970c5bf80cc98c7f3a3144745eac27"
    # upstream ticket: https://bugs.randombit.net/show_bug.cgi?id=267
    patch :DATA
  end

  bottle do
    cellar :any
    revision 1
    sha256 "c6566fa5d8f92bbeee2ff37995532ee40986f960981bde0e0045985679961565" => :el_capitan
    sha256 "0802cf4713c48a06a269247bfa6b80cecd03a6aac13ef2bdd209a557f4e5088a" => :yosemite
    sha256 "fc8b089c86ecbc7606a6e08868abdc0e370737bfa2b8f9fa2b170dfff9de5c1b" => :mavericks
  end

  devel do
    url "https://botan.randombit.net/releases/Botan-1.11.30.tgz"
    sha256 "8daf3adc8eb3b046ab4678beca5aef07af900c7781ddc88b10d1d966de66a125"
  end

  option "with-debug", "Enable debug build of Botan"

  deprecated_option "enable-debug" => "with-debug"

  depends_on "pkg-config" => :build
  depends_on "openssl"

  needs :cxx11 if build.devel?

  def install
    ENV.cxx11 if build.devel?

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --cpu=#{MacOS.preferred_arch}
      --cc=#{ENV.compiler}
      --os=darwin
      --with-openssl
      --with-zlib
      --with-bzip2
    ]

    args << "--enable-debug" if build.with? "debug"

    system "./configure.py", *args
    # A hack to force them use our CFLAGS. MACH_OPT is empty in the Makefile
    # but used for each call to cc/ld.
    system "make", "install", "MACH_OPT=#{ENV.cflags}"
  end

  test do
    # stable version doesn't have `botan` executable
    if !File.exist? bin/"botan"
      assert_match "lcrypto", shell_output("#{bin}/botan-config-1.10 --libs")
    else
      assert_match /\A-----BEGIN PRIVATE KEY-----/,
       shell_output("#{bin}/botan keygen")
    end
  end
end

__END__
--- a/src/build-data/makefile/unix_shr.in
+++ b/src/build-data/makefile/unix_shr.in
@@ -57,8 +57,8 @@
 LIBNAME       = %{lib_prefix}libbotan
 STATIC_LIB    = $(LIBNAME)-$(SERIES).a

-SONAME        = $(LIBNAME)-$(SERIES).%{so_suffix}.%{so_abi_rev}
-SHARED_LIB    = $(SONAME).%{version_patch}
+SONAME        = $(LIBNAME)-$(SERIES).%{so_abi_rev}.%{so_suffix}
+SHARED_LIB    = $(LIBNAME)-$(SERIES).%{so_abi_rev}.%{version_patch}.%{so_suffix}

 SYMLINK       = $(LIBNAME)-$(SERIES).%{so_suffix}
