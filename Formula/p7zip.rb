class P7zip < Formula
  desc "7-Zip (high compression file archiver) implementation"
  homepage "https://p7zip.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/p7zip/p7zip/16.02/p7zip_16.02_src_all.tar.bz2"
  sha256 "5eb20ac0e2944f6cb9c2d51dd6c4518941c185347d4089ea89087ffdd6e2341f"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "02255b08aef27b539f3fe17d64e45b7a9315a23d1063863c939c7d3ca5492eb1" => :mojave
    sha256 "3dd79783cfb9a66e220b94615ae88e3cf94dd41f60f4b07f81c30daabef8057e" => :high_sierra
    sha256 "d5a5d955cbe900f1a55142ba1c0265b17bf12118765e9bf369e1e02c499cfdad" => :sierra
  end

  patch do
    url "https://deb.debian.org/debian/pool/main/p/p7zip/p7zip_16.02+dfsg-6.debian.tar.xz"
    sha256 "fab0be1764efdbde1804072f1daa833de4e11ea65f718ad141a592404162643c"
    apply "patches/12-CVE-2016-9296.patch",
          "patches/13-CVE-2017-17969.patch"
  end

  def install
    mv "makefile.macosx_llvm_64bits", "makefile.machine"
    system "make", "all3",
                   "CC=#{ENV.cc} $(ALLFLAGS)",
                   "CXX=#{ENV.cxx} $(ALLFLAGS)"
    system "make", "DEST_HOME=#{prefix}",
                   "DEST_MAN=#{man}",
                   "install"
  end

  test do
    (testpath/"foo.txt").write("hello world!\n")
    system bin/"7z", "a", "-t7z", "foo.7z", "foo.txt"
    system bin/"7z", "e", "foo.7z", "-oout"
    assert_equal "hello world!\n", File.read(testpath/"out/foo.txt")
  end
end
