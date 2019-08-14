class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.0.2/fish-3.0.2.tar.gz"
  sha256 "14728ccc6b8e053d01526ebbd0822ca4eb0235e6487e832ec1d0d22f1395430e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "fcab9bbcf19d7535e364255ac0f0f5f412bb3cf0c1142fa6e0c206eda3093299" => :mojave
    sha256 "6533c03038a47c7dc77409e091d8dc18ec7ba9889a2f63b40ba4f24afee4a6b4" => :high_sierra
    sha256 "86f6b22ef5606c388a0672d4c6a7538f24bdd1277a1286fd178689c8b7e46d3d" => :sierra
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

  test do
    system "#{bin}/fish", "-c", "echo"
  end
end
