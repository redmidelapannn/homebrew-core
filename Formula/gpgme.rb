class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.13.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gpgme/gpgme-1.13.0.tar.bz2"
  sha256 "d4b23e47a9e784a63e029338cce0464a82ce0ae4af852886afda410f9e39c630"
  revision 1

  bottle do
    cellar :any
    sha256 "9a1db5edbaec6b9ae69b0e1bb735c29d4c87b5c09fa77876cd38538d66c04072" => :mojave
    sha256 "12fc32206785900dc9b1049fc83ec077932ae59a65b90fe5e9f99db90cc21510" => :high_sierra
    sha256 "24c5dca7e9033ef0a6d911c660fd71455b358052437b378e733266f25489d9d4" => :sierra
  end

  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => [:build, :test]
  depends_on "swig" => :build
  depends_on "cmake" => :test
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgpg-error"
  depends_on "qt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpgme-config", prefix, opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gpgme-tool --lib-version")
    system "python2.7", "-c", "import gpg; print gpg.version.versionstr"
    system "python3", "-c", "import gpg; print(gpg.version.versionstr)"
    (testpath/"CMakeLists.txt").write("find_package(QGpgme REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
