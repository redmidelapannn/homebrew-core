class Kyua < Formula
  desc "Testing framework for infrastructure software"
  homepage "https://github.com/jmmv/kyua"
  url "https://github.com/jmmv/kyua/releases/download/kyua-0.13/kyua-0.13.tar.gz"
  sha256 "db6e5d341d5cf7e49e50aa361243e19087a00ba33742b0855d2685c0b8e721d6"
  revision 1

  bottle do
    rebuild 1
    sha256 "c2b8de64f429fd331bfa959b4aaa04f794d3985b6313aad1a7fea01b0a17e259" => :high_sierra
    sha256 "d5084a561596e40741c551164c2ef260cad8c9231c823cb13b91fa1aaec6c5f1" => :sierra
    sha256 "29e30cd27a369d9b01685691bb948fb134f99082d83ab55c0d0de83634e38643" => :el_capitan
  end

  depends_on "atf"
  depends_on "lutok"
  depends_on "pkg-config" => :build
  depends_on "lua"
  depends_on "sqlite"

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["lua"].opt_include}/lua"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end
end
