class Etl < Formula
  desc "Extensible Template Library"
  homepage "http://synfig.org"
  url "https://downloads.sourceforge.net/project/synfig/releases/1.0.2/source/ETL-0.04.19.tar.gz"
  sha256 "ba944c1a07fd321488f9d034467931b8ba9e48454abef502a633ff4835380c1c"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "7721915523125c90441a3106096219e296206969bb78335e7e71f3c49d0a7af1" => :mavericks
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
