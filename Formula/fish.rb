class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.0.0/fish-3.0.0.tar.gz"
  sha256 "ea9dd3614bb0346829ce7319437c6a93e3e1dfde3b7f6a469b543b0d2c68f2cf"

  bottle do
    cellar :any
    sha256 "3b63dba3926726e84e99c8cc3120d159a60ace89d0e186a015f5014b0db3504a" => :mojave
    sha256 "0bb9e1118a5e71583e10a17fe9565739c070e17627b5c433805c25e13eb1e661" => :high_sierra
    sha256 "96257e43d6f394a65d50abfddc675c3757553a4e6d7956d3f0e4e61c70f5758e" => :sierra
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

  def post_install
    (pkgshare/"vendor_functions.d").mkpath
    (pkgshare/"vendor_completions.d").mkpath
    (pkgshare/"vendor_conf.d").mkpath
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

  test do
    system "#{bin}/fish", "-c", "echo"
  end
end
