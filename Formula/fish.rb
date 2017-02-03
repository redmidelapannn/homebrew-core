class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"

  stable do
    url "https://github.com/fish-shell/fish-shell/releases/download/2.5.0/fish-2.5.0.tar.gz"
    mirror "https://fishshell.com/files/2.5.0/fish-2.5.0.tar.gz"
    sha256 "f8c0edadca2de379ccf305aeace660a9255fa2180c72e85e97705a24c256b2a5"
  end

  bottle do
    rebuild 1
    sha256 "77faf7d55bd9a757cfd8f5184f3b875ab790a523b2be053a71746e11a88d03c0" => :sierra
    sha256 "cfde34d691966a1d532b255bf08e7491d3a6f5fd9b4a4f7516d903bac6f8bb06" => :el_capitan
    sha256 "5f0cfb596a3a5809bb4c01bcd01fa080d4d7a857822a35ad58fcfcf5c0d8b466" => :yosemite
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "doxygen" => :build
  end

  depends_on "pcre2"

  def install
    system "autoreconf", "--no-recursive" if build.head?

    # In Homebrew's 'superenv' sed's path will be incompatible, so
    # the correct path is passed into configure here.
    args = %W[
      --prefix=#{prefix}
      --with-extra-functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d
      --with-extra-completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d
      --with-extra-confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d
      SED=/usr/bin/sed
    ]
    system "./configure", *args
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

  def post_install
    (pkgshare/"vendor_functions.d").mkpath
    (pkgshare/"vendor_completions.d").mkpath
    (pkgshare/"vendor_conf.d").mkpath
  end

  test do
    system "#{bin}/fish", "-c", "echo"
  end
end
