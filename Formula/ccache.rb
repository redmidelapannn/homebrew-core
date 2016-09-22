class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https://ccache.samba.org/"
  url "https://www.samba.org/ftp/ccache/ccache-3.3.1.tar.xz"
  sha256 "c6d87a49cc6d7639636d289ed9a5f560bc2acf7ab698fe8ee14e9c9f15ba41c6"

  bottle do
    rebuild 1
    sha256 "00bad63c1c05751940ad8e6279f35edf31aa0312fa7acdf77cf04dc92e4c5a3c" => :sierra
    sha256 "ee62d5977f2ce13c32124172a82b319d57fd73b401486882156d035c121890eb" => :el_capitan
    sha256 "782b4948c2f3a9f9c7b44c658d13152d70bdda8fcc378ba96ccd95e191e9c122" => :yosemite
  end

  head do
    url "https://github.com/ccache/ccache.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "asciidoc" => ["with-docbook-xsl", :build]
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog" if build.head?

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--with-bundled-zlib"
    system "make"
    system "make", "install"

    libexec.mkpath

    %w[
      clang
      clang++
      cc
      gcc gcc2 gcc3 gcc-3.3 gcc-4.0 gcc-4.2 gcc-4.3 gcc-4.4 gcc-4.5 gcc-4.6 gcc-4.7 gcc-4.8 gcc-4.9 gcc-5 gcc-6
      c++ c++3 c++-3.3 c++-4.0 c++-4.2 c++-4.3 c++-4.4 c++-4.5 c++-4.6 c++-4.7 c++-4.8 c++-4.9 c++-5 c++-6
      g++ g++2 g++3 g++-3.3 g++-4.0 g++-4.2 g++-4.3 g++-4.4 g++-4.5 g++-4.6 g++-4.7 g++-4.8 g++-4.9 g++-5 g++-6
    ].each do |prog|
      libexec.install_symlink bin/"ccache" => prog
    end
  end

  def caveats; <<-EOS.undent
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
