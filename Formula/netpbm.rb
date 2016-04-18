class Netpbm < Formula
  desc "Image manipulation"
  homepage "http://netpbm.sourceforge.net"
  # Maintainers: Look at https://sourceforge.net/p/netpbm/code/HEAD/tree/
  # for versions and matching revisions
  url "http://svn.code.sf.net/p/netpbm/code/advanced", :revision => 2294
  version "10.68"

  head "http://svn.code.sf.net/p/netpbm/code/trunk"

  bottle do
    cellar :any
    revision 3
    sha256 "4c2f7c5a8632f7e9aba711f1d9b4cb5cbe08650d586f58bb6ccdc753f3681c2e" => :el_capitan
    sha256 "fc688998c57713c88a19946f962cb6d02382c167591a12413b0155a9079cad48" => :yosemite
    sha256 "838fb6d21c820ccad80ca3fd7fd50188d4bbfff4e320fd3c098b93d17c7aef5d" => :mavericks
  end

  option :universal

  depends_on "libtiff"
  depends_on "jasper"
  depends_on "libpng"

  def install
    ENV.universal_binary if build.universal?

    cp "config.mk.in", "config.mk"

    inreplace "config.mk" do |s|
      s.remove_make_var! "CC"
      s.change_make_var! "CFLAGS_SHLIB", "-fno-common"
      s.change_make_var! "NETPBMLIBTYPE", "dylib"
      s.change_make_var! "NETPBMLIBSUFFIX", "dylib"
      s.change_make_var! "LDSHLIB", "--shared -o $(SONAME)"
      s.change_make_var! "TIFFLIB", "-ltiff"
      s.change_make_var! "JPEGLIB", "-ljpeg"
      s.change_make_var! "PNGLIB", "-lpng"
      s.change_make_var! "ZLIB", "-lz"
      s.change_make_var! "JASPERLIB", "-ljasper"
      s.change_make_var! "JASPERHDR_DIR", "#{Formula["jasper"].opt_include}/jasper"
    end

    ENV.deparallelize
    system "make"
    system "make", "package", "pkgdir=#{buildpath}/stage"

    cd "stage" do
      inreplace "pkgconfig_template" do |s|
        s.gsub! "@VERSION@", File.read("VERSION").sub("Netpbm ", "").chomp
        s.gsub! "@LINKDIR@", lib
        s.gsub! "@INCLUDEDIR@", include
      end

      prefix.install %w[bin include lib misc]
      # do man pages explicitly; otherwise a junk file is installed in man/web
      man1.install Dir["man/man1/*.1"]
      man5.install Dir["man/man5/*.5"]
      lib.install Dir["link/*.a"]
      (lib/"pkgconfig").install "pkgconfig_template" => "netpbm.pc"
    end

    (bin/"doc.url").unlink
  end

  test do
    system ("#{bin}/pngtopam #{test_fixtures("test.png")} -alphapam >> test.pam")
    system "#{bin}/pamdice", "test.pam", "-outstem", "#{testpath}/testing"
    assert File.exist?("testing_0_0.")
  end
end
