class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/2.7.1/fish-2.7.1.tar.gz"
  mirror "https://fishshell.com/files/2.7.1/fish-2.7.1.tar.gz"
  sha256 "e42bb19c7586356905a58578190be792df960fa81de35effb1ca5a5a981f0c5a"

  bottle do
    rebuild 1
    sha256 "a3bbfcf0bddba628f57160a9e8283224c117a90be8c2e6188a236b309762018e" => :high_sierra
    sha256 "c343dfb208b78a066c37392e66185e50070aa3535503e671ed9b4652a7841376" => :sierra
    sha256 "937ceae2ec7d75c30649fccc5aec1b6415eb77d558980e856ab274c64872a87a" => :el_capitan
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
