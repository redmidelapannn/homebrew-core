class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftp.gnu.org/gnu/gawk/gawk-4.2.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gawk/gawk-4.2.1.tar.xz"
  sha256 "d1119785e746d46a8209d28b2de404a57f983aa48670f4e225531d3bdc175551"
  revision 1

  bottle do
    sha256 "ba06927a5863202d59d35dd858023be3f1ef4b68da7c7fe51e55a831d0ae4d77" => :high_sierra
    sha256 "08f2ee4fe2823abdca811c5f75471d62345fcb5e0ccddafce2d52fa101f6fd0e" => :sierra
    sha256 "3b816456a4c28d6c4d3ba918a29c109eac2e27ab73593781ac983f4c17206964" => :el_capitan
  end

  depends_on "gettext"
  depends_on "mpfr"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-libsigsegv-prefix"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/gawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
