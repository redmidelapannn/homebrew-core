class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https://ccache.dev/"
  url "https://github.com/ccache/ccache/releases/download/v3.7.1/ccache-3.7.1.tar.xz"
  sha256 "66fc121a2a33968f9ec428e02f48ff4b8896fbabb759e9c09352267014dcbe65"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7ae69c5b9e413eed4965b523eedb5c215bba01172353c3b438c5c921da138040" => :mojave
    sha256 "aae3f2b6b4bb44efbb263498506abb5140b6ddaf9e0f2d11ec74950848d3c902" => :high_sierra
    sha256 "f03faf73d145b3dc2b3811b376b7a3be8f1419f3676b5db22f73428cc508847e" => :sierra
  end

  uses_from_macos "zlib"

  head do
    url "https://github.com/ccache/ccache.git"

    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog" if build.head?

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"

    libexec.mkpath

    %w[
      clang
      clang++
      cc
      gcc gcc2 gcc3 gcc-3.3 gcc-4.0 gcc-4.2 gcc-4.3 gcc-4.4 gcc-4.5 gcc-4.6 gcc-4.7 gcc-4.8 gcc-4.9 gcc-5 gcc-6 gcc-7
      c++ c++3 c++-3.3 c++-4.0 c++-4.2 c++-4.3 c++-4.4 c++-4.5 c++-4.6 c++-4.7 c++-4.8 c++-4.9 c++-5 c++-6 c++-7
      g++ g++2 g++3 g++-3.3 g++-4.0 g++-4.2 g++-4.3 g++-4.4 g++-4.5 g++-4.6 g++-4.7 g++-4.8 g++-4.9 g++-5 g++-6 g++-7
    ].each do |prog|
      libexec.install_symlink bin/"ccache" => prog
    end
  end

  def caveats; <<~EOS
    To install symlinks for compilers that will automatically use
    ccache, prepend this directory to your PATH:
      #{opt_libexec}

    If this is an upgrade and you have previously added the symlinks to
    your PATH, you may need to modify it to the path specified above so
    it points to the current version.

    NOTE: ccache can prevent some software from compiling.
    ALSO NOTE: The brew command, by design, will never use ccache.
  EOS
  end

  test do
    ENV.prepend_path "PATH", opt_libexec
    assert_equal "#{opt_libexec}/gcc", shell_output("which gcc").chomp
    system "#{bin}/ccache", "-s"
  end
end
