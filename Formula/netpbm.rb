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
    sha256 "711a9b85fc3e0cff750e13b227d35dfdd586549559ab07768be31df7772eb54f" => :el_capitan
    sha256 "d2de25214bccb8241fe8248b7faa4543ea2640155248e36ec2341876777b2dbf" => :yosemite
    sha256 "bedba20e3f33974a59366801e791c96098c3e43309a52b39cbd91252a672d683" => :mavericks
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
