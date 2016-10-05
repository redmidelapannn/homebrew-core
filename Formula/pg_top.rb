class PgTop < Formula
  desc "Monitor PostgreSQL processes"
  homepage "http://ptop.projects.postgresql.org/"
  url "http://pgfoundry.org/frs/download.php/3504/pg_top-3.7.0.tar.bz2"
  sha256 "c48d726e8cd778712e712373a428086d95e2b29932e545ff2a948d043de5a6a2"
  revision 1

  bottle do
    cellar :any
    sha256 "f95c91f77d8bfe25a3e330c12594f6fbeb15319df54fc1f0e7dc5abe66a26418" => :sierra
    sha256 "e0f208639cfc0c3fcfd257298bce229d2d2325eb4e3d2dc8200d8bdf3250eb3c" => :el_capitan
    sha256 "84604c4231d85ead3981a145994990360f4af6e56fbad4c0e3c2d50ad8ad6000" => :yosemite
  end

  depends_on :postgresql

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    (buildpath/"config.h").append_lines "#define HAVE_DECL_STRLCPY 1" if MacOS.version >= :mavericks
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pg_top -V")
  end
end
