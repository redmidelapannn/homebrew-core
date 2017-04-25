class Make < Formula
  desc "Utility for directing compilation"
  homepage "https://www.gnu.org/software/make/"
  url "https://ftp.gnu.org/gnu/make/make-4.2.1.tar.bz2"
  mirror "https://ftpmirror.gnu.org/make/make-4.2.1.tar.bz2"
  sha256 "d6e262bf3601b42d2b1e4ef8310029e1dcf20083c5446b4b7aa67081fdffc589"

  bottle do
    rebuild 1
    sha256 "3b881132cc18d9a13f6bae6399e022e3ba07071b246f71fe1c993275f093c8ed" => :yosemite
    sha256 "c8757275b6f8baf14b575b27c30f1b47b1a77885213511eb31c214e8951be464" => :sierra
    sha256 "4fb0b1323d31e12e2ea7bbc0f80755344f3164e1e1162c0a05ee5ef35fb5b056" => :el_capitan
  end

  option "with-default-names", "Do not prepend 'g' to the binary"

  deprecated_option "with-guile" => "with-guile@2.0"

  depends_on "guile@2.0" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--with-guile" if build.with? "guile@2.0"
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"Makefile").write <<-EOS.undent
      default:
      \t@echo Homebrew
    EOS

    cmd = build.with?("default-names") ? "make" : "gmake"

    assert_equal "Homebrew\n",
      shell_output("#{bin}/#{cmd}")
  end
end
