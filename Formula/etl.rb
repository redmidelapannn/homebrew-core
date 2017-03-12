class Etl < Formula
  desc "Extensible Template Library"
  homepage "https://synfig.org"
  url "https://downloads.sourceforge.net/project/synfig/releases/1.0.2/source/ETL-0.04.19.tar.gz"
  sha256 "ba944c1a07fd321488f9d034467931b8ba9e48454abef502a633ff4835380c1c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2b1d2857e999aca9cb30adaf6022c4a7b511f7b661411c802cac24e824c09e5c" => :sierra
    sha256 "2b1d2857e999aca9cb30adaf6022c4a7b511f7b661411c802cac24e824c09e5c" => :el_capitan
    sha256 "2b1d2857e999aca9cb30adaf6022c4a7b511f7b661411c802cac24e824c09e5c" => :yosemite
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <ETL/misc>
      int main(int argc, char *argv[])
      {
        int rv = etl::ceil_to_int(5.5);
        return 6 - rv;
      }
    EOS
    flags = %W[
      -I#{include}
      -lpthread
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
