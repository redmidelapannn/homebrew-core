class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"

  stable do
    url "https://fishshell.com/files/2.4.0/fish-2.4.0.tar.gz"
    mirror "https://github.com/fish-shell/fish-shell/releases/download/2.4.0/fish-2.4.0.tar.gz"
    sha256 "06bbb2323360439c4044da762d114ec1aa1aba265cec71c0543e6a0095c9efc5"
  end

  bottle do
    rebuild 1
    sha256 "66698c7ff27c8bcc283c756167a5449b309821dd203c7febc2c8f350963c48b7" => :sierra
    sha256 "b564718810519a30495bfa20f3c0e374447a22faac06df5a3704bb8001afd65b" => :el_capitan
    sha256 "e446322eace124160aa6ac86f52246e085efb63a3f1f93481b24c02bc5825f43" => :yosemite
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
