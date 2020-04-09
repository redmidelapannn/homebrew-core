class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.13.1.tar.bz2"
  sha256 "c4e30b227682374c23cddc7fdb9324a99694d907e79242a25a4deeedb393be46"
  revision 1

  bottle do
    cellar :any
    sha256 "02782847431582eef955c87d0e927cb4424e15c9444be20e2a2ed3d90241cb68" => :catalina
    sha256 "e0559ac1602d178eeaaa974b5dc63dbb2e45e6b2754a85df97af25a6ecab2644" => :mojave
    sha256 "3ef59d24641f322929fc4adc5a5899505e02d17121a08d3d783d26b12c099411" => :high_sierra
  end

  depends_on "python@3.8" => [:build, :test]
  depends_on "swig" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgpg-error"

  def install
    ENV["PYTHON"] = Formula["python@3.8"].opt_bin/"python3"

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
    system Formula["python@3.8"].opt_bin/"python3", "-c", "import gpg; print(gpg.version.versionstr)"
  end
end
