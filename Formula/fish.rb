class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://fishshell.com/files/2.3.1/fish-2.3.1.tar.gz"
  mirror "https://github.com/fish-shell/fish-shell/releases/download/2.3.1/fish-2.3.1.tar.gz"
  sha256 "328acad35d131c94118c1e187ff3689300ba757c4469c8cc1eaa994789b98664"

  bottle do
    sha256 "852d440fd58cde4473ba35f732c7bdfb675c9083891aeb5c54d15d567b54de2f" => :el_capitan
    sha256 "9367a6ec60e99b38143a683cb8529f07cb1be58ced1330410c5b1f1474d16799" => :yosemite
    sha256 "e1e3f0e0d6b32cfa95ff4d5c082252033e4ec3c7c49bb5bdb26f3e55bff7f6af" => :mavericks
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "doxygen" => :build
  end

  depends_on "pcre2"

  def install
    system "autoconf" if build.head? || build.devel?
    # In Homebrew's 'superenv' sed's path will be incompatible, so
    # the correct path is passed into configure here.
    system "./configure", "--prefix=#{prefix}", "SED=/usr/bin/sed"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    You will need to add:
      #{HOMEBREW_PREFIX}/bin/fish
    to /etc/shells.

    Then run:
      chsh -s #{HOMEBREW_PREFIX}/bin/fish
    to make fish your default shell.
    EOS
  end

  test do
    system "#{bin}/fish", "-c", "echo"
  end
end
