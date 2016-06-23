class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://cmake.org/files/v3.5/cmake-3.5.2.tar.gz"
  sha256 "92d8410d3d981bb881dfff2aed466da55a58d34c7390d50449aa59b32bb5e62a"

  head "https://cmake.org/cmake.git"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "bfd00671f5da16d3e4dc10b2c0b9f684dd9fe1411be286e4841ccc410d70273f" => :el_capitan
    sha256 "12e25b601e795804350a660543aa9bec0a73d8dcd7d990dd6f2d5e52f955e9e0" => :yosemite
    sha256 "f1fca2180749d78b28327ef4ff3dd95a42e686f0026288e57341e87e978d1fa3" => :mavericks
  end

  devel do
    url "https://cmake.org/files/v3.6/cmake-3.6.0-rc3.tar.gz"
    sha256 "3a6aff86a3ae93253456dfc8196034b2a580a0c3bc34174d99a2e5175bc578c6"
  end

  option "without-docs", "Don't build man pages"
  option "with-completion", "Install Bash completion (Has potential problems with system bash)"

  depends_on "sphinx-doc" => :build if build.with? "docs"

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use brew install caskroom/cask/cmake.

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --system-zlib
      --system-bzip2
    ]

    # https://github.com/Homebrew/homebrew/issues/45989
    if MacOS.version <= :lion
      args << "--no-system-curl"
    else
      args << "--system-curl"
    end

    if build.with? "docs"
      # There is an existing issue around OS X & Python locale setting
      # See https://bugs.python.org/issue18378#msg215215 for explanation
      ENV["LC_ALL"] = "en_US.UTF-8"
      args << "--sphinx-man" << "--sphinx-build=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"
    end

    system "./bootstrap", *args
    system "make"
    system "make", "install"

    if build.with? "completion"
      cd "Auxiliary/bash-completion/" do
        bash_completion.install "ctest", "cmake", "cpack"
      end
    end

    (share/"emacs/site-lisp/cmake").install "Auxiliary/cmake-mode.el"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system "#{bin}/cmake", "."
  end
end
