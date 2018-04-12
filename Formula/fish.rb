class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/2.7.1/fish-2.7.1.tar.gz"
  mirror "https://fishshell.com/files/2.7.1/fish-2.7.1.tar.gz"
  sha256 "e42bb19c7586356905a58578190be792df960fa81de35effb1ca5a5a981f0c5a"

  bottle do
    rebuild 1
    sha256 "ce2abb19cb379c8bd0ccf0c2cb90883e95d5a8088b5cf0444ba0a34dd30e905c" => :high_sierra
    sha256 "973a202d72dc742c026217951873b515485e9f91c3e6ca12927de434f3d6eb60" => :sierra
    sha256 "707154d1e229f15390ff1c70b76b209e59cd77be23edd97cf902b60dc2cc8b9c" => :el_capitan
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", :shallow => false

    depends_on "cmake" => :build
    depends_on "doxygen" => :build
  end

  depends_on "pcre2"

  def install
    if build.head?
      args = %W[
        -Dextra_functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d
        -Dextra_completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d
        -Dextra_confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d
        -DSED=/usr/bin/sed
      ]
      system "cmake", ".", *std_cmake_args, *args
    else
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
    end
    system "make", "install"
  end

  def caveats; <<~EOS
    You will need to add:
      #{HOMEBREW_PREFIX}/bin/fish
    to /etc/shells for example:
      echo #{HOMEBREW_PREFIX}/bin/fish | sudo tee -a /etc/shells

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
