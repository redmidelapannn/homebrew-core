class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.0.2/fish-3.0.2.tar.gz"
  sha256 "14728ccc6b8e053d01526ebbd0822ca4eb0235e6487e832ec1d0d22f1395430e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1463d9cee9e34ab1d74986d0ff1b562ebc328c16555426a1bc80dc8aefa1094b" => :mojave
    sha256 "596d8baada3d728a3a881859020c70545f1b176c792ad92102ac4f1e4a4c0197" => :high_sierra
    sha256 "e7444bbb0d158ef670e28d9ea27db59aff621348ac526019fb534c0c42cdda10" => :sierra
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", :shallow => false

    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
  depends_on "pcre2"
  uses_from_macos "ncurses"

  def install
    # In Homebrew's 'superenv' sed's path will be incompatible, so
    # the correct path is passed into configure here.
    args = %W[
      -Dextra_functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d
      -Dextra_completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d
      -Dextra_confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d
      -DSED=/usr/bin/sed
    ]
    system "cmake", ".", *std_cmake_args, *args
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
