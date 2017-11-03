class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"

  stable do
    url "https://github.com/fish-shell/fish-shell/releases/download/2.6.0/fish-2.6.0.tar.gz"
    mirror "https://fishshell.com/files/2.6.0/fish-2.6.0.tar.gz"
    sha256 "7ee5bbd671c73e5323778982109241685d58a836e52013e18ee5d9f2e638fdfb"
  end

  bottle do
    rebuild 1
    sha256 "0d1827be683aa03101ad46c8782d7cfc21764907ddd5c7727ec65c4be90e61fc" => :high_sierra
    sha256 "6d13bfcde957179a48c87a6e5ec03d883f5d6a3c301613512d7cb08a9d313d32" => :sierra
    sha256 "27a4af881d54dfe678468605214bcc806026302e8ecc12af9e0a3f5df91eb52a" => :el_capitan
  end

  devel do
    url "https://github.com/fish-shell/fish-shell/releases/download/2.7b1/fish-2.7b1.tar.gz"
    sha256 "326dbea5d0f20eba54fa0b0c5525e58b4a39ebd8c52c14cfffc5f4d6cdf55385"
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

  def caveats; <<~EOS
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
