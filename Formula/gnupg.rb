class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-1.4.20.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.20.tar.bz2"
  sha256 "04988b1030fa28ddf961ca8ff6f0f8984e0cddcb1eb02859d5d8fe0fe237edcc"
  revision 2

  bottle do
    revision 1
    sha256 "abe17dcfc42834a653479ebc694bfd4c49ddcca117717cca0cd44516a310a3f7" => :el_capitan
    sha256 "b71ede20a9d2269dd3447122bfe5acbe2c62757a7b82045d995685c295b7d1b4" => :yosemite
    sha256 "2972023aded0cf1309e23dc0a9cd13197003c19a997d986fc14f5744955a4211" => :mavericks
  end

  depends_on "curl" if MacOS.version <= :mavericks
  depends_on "libusb-compat" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-asm
      --program-suffix=1
    ]
    args << "--with-libusb=no" if build.without? "libusb-compat"

    system "./configure", *args
    system "make"
    system "make", "check"

    # we need to create these directories because the install target has the
    # dependency order wrong
    [bin, libexec/"gnupg"].each(&:mkpath)
    system "make", "install"

    # Although gpg2 support should be pretty universal these days
    # keep vanilla `gpg` executables available, at least for now.
    %w[gpg-zip1 gpg1 gpgsplit1 gpgv1].each do |cmd|
      (libexec/"gpgbin").install_symlink bin/cmd => cmd.to_s.sub(/1/, "")
    end
  end

  def caveats; <<-EOS.undent
    This formula does not install either `gpg` or `gpgv` executables into
    into the PATH.

    If you really need to use these tools without the "1" suffix you can
    add a "gpgbin" directory to your PATH from your #{shell_profile} like:

        PATH="#{opt_libexec}/gpgbin:$PATH"

    Note that doing so may interfere with GPG-using formulae installed via
    Homebrew.

    If you simply require vanilla `gpg` and `gpgv` executables without
    explicitly needing GnuPG 1.x we recommend:
      brew install gnupg2
    EOS
  end

  test do
    (testpath/"batchgpg").write <<-EOS.undent
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %commit
    EOS
    system bin/"gpg1", "--batch", "--gen-key", "batchgpg"
    (testpath/"test.txt").write "Hello World!"
    system bin/"gpg1", "--armor", "--sign", "test.txt"
    system bin/"gpg1", "--verify", "test.txt.asc"
  end
end
