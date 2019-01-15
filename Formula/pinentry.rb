class Pinentry < Formula
  desc "Passphrase entry dialog utilizing the Assuan protocol"
  homepage "https://www.gnupg.org/related_software/pinentry/"
  url "https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-1.1.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/pinentry/pinentry-1.1.0.tar.bz2"
  sha256 "68076686fa724a290ea49cdf0d1c0c1500907d1b759a3bcbfbec0293e8f56570"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "50e29c54519a03f8ff58817f072bd6b93571e76b8d1a93065fc21a864bd56515" => :mojave
    sha256 "2ff89b4c34501b0b86b8b739335732afb8f0c74e40f06a7310469b75dd783245" => :high_sierra
    sha256 "7717588a434686f98fee0e23f23336c302988818171f2be6d788b593fb122ac9" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libassuan"
  depends_on "libgpg-error"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-pinentry-fltk
      --disable-pinentry-gnome3
      --disable-pinentry-gtk2
      --disable-pinentry-qt
      --disable-pinentry-qt5
      --disable-pinentry-tqt
      --enable-pinentry-tty
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pinentry", "--version"
    system "#{bin}/pinentry-tty", "--version"
  end
end
