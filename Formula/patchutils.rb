class Patchutils < Formula
  desc "Small collection of programs that operate on patch files"
  homepage "http://cyberelk.net/tim/software/patchutils/"
  url "http://cyberelk.net/tim/data/patchutils/stable/patchutils-0.3.4.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/p/patchutils/patchutils_0.3.4.orig.tar.xz"
  sha256 "cf55d4db83ead41188f5b6be16f60f6b76a87d5db1c42f5459d596e81dabe876"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "9129e329555e6724a8bfa1b8bdd3f99ec2b2e9a7ec5a5fc64e5d15594b230034" => :high_sierra
    sha256 "f488c72c4af22bd6fbf22e4b520ee9326894441aedc37dd118dddd1e3d7790e1" => :sierra
    sha256 "10646231cb3b93307b1e93624b59a15212173a59f55dae1b5cc31b62e6c82e84" => :el_capitan
  end

  head do
    url "https://github.com/twaugh/patchutils.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "docbook" => :build
  end

  depends_on "xmlto" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog" if build.head?
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match %r{a\/libexec\/NOOP}, shell_output("#{bin}/lsdiff #{test_fixtures("test.diff")}")
  end
end
