class Fcgene < Formula
  desc "Format-converting tool for genotype data"
  homepage "https://sourceforge.net/projects/fcgene/"
  url "https://downloads.sourceforge.net/project/fcgene/fcgene-1.0.7.tar.gz"
  sha256 "4e1f85f2ec812e2528bd19b6c18ecf297666cd83046e003bc57d9ed5f25783d6"

  bottle do
    cellar :any_skip_relocation
    sha256 "790dc71d26d58047163404f3fb27710d3cbe3675ee1c4627b1f0ee537b817809" => :sierra
    sha256 "7712c3fbc525150d63262d4396b9eb648532e2241529ca811fd9b50a3f49e07c" => :el_capitan
  end

  def install
    ENV["AC_CXX"] = ENV["CXX"] # otherwise CXX is ignored
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.ped").write("1 1000000000 0 0 1 1 0 0 1 1\n1 1000000001 0 0 1 2 1 1 1 2\n")
    (testpath/"test.map").write("1 rs0 0 1000\n1 rs10 0 1001\n")
    system "#{bin}/fcgene", "--ped", "test.ped", "--map", "test.map"
    assert_predicate testpath/"fcgene_out_fcgene.log", :exist?
  end
end
