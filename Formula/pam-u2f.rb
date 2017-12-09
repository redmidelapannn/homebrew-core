class PamU2f < Formula
  desc "Provides an easy way to use U2F-compliant authenticators with PAM"
  homepage "https://developers.yubico.com/pam-u2f/"
  url "https://developers.yubico.com/pam-u2f/Releases/pam_u2f-1.0.4.tar.gz"
  sha256 "71542e4568e6d2acaa50810a93c67297ba402f960da1ebb621413bd31f0732a1"
  revision 1
  head "https://github.com/Yubico/pam-u2f.git"

  bottle do
    cellar :any
    sha256 "435fd5f19b4df1877cd39333a4f63a4ef50b1d75385328a1258f1082ceaef88a" => :high_sierra
    sha256 "36dd871229fba11d4fa12c261a5fe0ae24d430538591cc77eb0c846ac9d461f9" => :sierra
    sha256 "ed4a3299f24d61ac533e831d2393129c78904f18820abefc8a14ae9ef4a55970" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "asciidoc" => :build
  depends_on "libu2f-host"
  depends_on "libu2f-server"

  def install
    system "autoreconf", "--install"

    ENV["A2X"] = "#{Formula["asciidoc"].opt_bin}/a2x --no-xmllint"
    system "./configure", "--prefix=#{prefix}", "--with-pam-dir=#{lib}/pam"
    system "make", "install"
  end

  def caveats; <<~EOS
    To use a U2F key for PAM authentication, specify the full path to the
    module (#{opt_lib}/pam/pam_u2f.so) in a PAM
    configuration. You can find all PAM configurations in /etc/pam.d.

    For further installation instructions, please visit
    https://developers.yubico.com/pam-u2f/#installation.
    EOS
  end

  test do
    system "#{bin}/pamu2fcfg", "--version"
  end
end
