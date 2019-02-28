class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.0.2/fish-3.0.2.tar.gz"
  sha256 "14728ccc6b8e053d01526ebbd0822ca4eb0235e6487e832ec1d0d22f1395430e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1143c6a255b3c278c34fdf09fb16062c8438c82cd8e03171a54f15a3a78b03ce" => :mojave
    sha256 "93914190562cbdef7d6a367ddd041545b4a49371bcc527796cb90dd9c40d554e" => :high_sierra
    sha256 "f4b119994bb36e6e3529aa14f3e50d4b3ed9ecf40c42cb68b68e927c5aea29ca" => :sierra
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", :shallow => false

    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
  depends_on "pcre2"

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
