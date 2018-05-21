class GnuGetopt < Formula
  desc "Command-line option parsing library"
  homepage "http://software.frodo.looijaard.name/getopt/"
  url "http://frodo.looijaard.name/system/files/software/getopt/getopt-1.1.6.tar.gz"
  mirror "https://fossies.org/linux/misc/getopt-1.1.6.tar.gz"
  sha256 "d0bf1dc642a993e7388a1cddfb9409bed375c21d5278056ccca3a0acd09dc5fe"

  bottle do
    rebuild 1
    sha256 "3ad6ad5d958887595728fecd9e1c5b8a1df50f84ee66b5ca25d338beb1a62f33" => :high_sierra
    sha256 "58aeb04ee16d2f0de2acdc368b0c3f5309a6f3c4617d041cc8575194b75f4a9d" => :sierra
    sha256 "848175defdadf358223b229df29b8f063320408abab21e4205a9e39ad4075720" => :el_capitan
  end

  keg_only :provided_by_macos

  depends_on "gettext"

  def install
    inreplace "Makefile" do |s|
      gettext = Formula["gettext"]
      s.change_make_var! "CPPFLAGS", "\\1 -I#{gettext.include}"
      s.change_make_var! "LDFLAGS", "\\1 -L#{gettext.lib} -lintl"
    end
    system "make", "prefix=#{prefix}", "mandir=#{man}", "install"
  end

  test do
    system "#{bin}/getopt", "-o", "--test"
  end
end
