class Pyexiv2 < Formula
  desc "Python binding to exiv2 for manipulation of image metadata"
  homepage "http://tilloy.net/dev/pyexiv2/"
  url "https://launchpad.net/pyexiv2/0.3.x/0.3.2/+download/pyexiv2-0.3.2.tar.bz2"
  sha256 "0abc117c6afa71f54266cb91979a5227f60361db1fcfdb68ae9615398d7a2127"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "25de2c07e70c5631e2672681313ad7d1d5ab2fbc97fffc30ea4b386ecda0856c" => :sierra
    sha256 "38920a1b9eef9740f968c332b1737205c17720f063380fc339fa5e32190eabe6" => :el_capitan
    sha256 "ca47ce699e5726b00c640cf70a74a21441350b2bac4471c530c2847dbb9e5f89" => :yosemite
  end

  depends_on "scons" => :build
  depends_on "exiv2"
  depends_on "boost"
  depends_on "boost-python"

  def install
    # this build script ignores CPPFLAGS, but it honors CXXFLAGS
    ENV.append "CXXFLAGS", ENV.cppflags
    ENV.append "CXXFLAGS", "-I#{Formula["boost"].include}"
    ENV.append "CXXFLAGS", "-I#{Formula["exiv2"].include}"
    ENV.append "LDFLAGS", "-undefined dynamic_lookup"

    scons "BOOSTLIB=boost_python-mt"

    # let's install manually
    mv "build/libexiv2python.dylib", "build/libexiv2python.so"
    (lib+"python2.7/site-packages").install "build/libexiv2python.so", "src/pyexiv2"
    pkgshare.install "test/data/smiley1.jpg"
  end

  test do
    (testpath/"test.py").write <<-EOS.undent
      import pyexiv2
      metadata = pyexiv2.ImageMetadata("#{pkgshare}/smiley1.jpg")
      metadata.read()
      assert "Exif.Image.ImageDescription" in metadata.exif_keys
    EOS
    system "python", testpath/"test.py"
  end
end
