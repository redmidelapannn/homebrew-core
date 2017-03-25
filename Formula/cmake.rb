class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://cmake.org/files/v3.7/cmake-3.7.2.tar.gz"
  sha256 "dc1246c4e6d168ea4d6e042cfba577c1acd65feea27e56f5ff37df920c30cae0"
  head "https://cmake.org/cmake.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4291d96b1bbfb81f7236efe5bc00bbf4f51b2ba814842705df9295da636ae708" => :sierra
    sha256 "62053341bee5147aa81fed27b3e1c56d51a8b3439799369248ca23c0c677fbb1" => :el_capitan
    sha256 "62ff1ecb12336fabadaf73458b8466e66dacf3888656cc074c0ac08f9af03b1e" => :yosemite
  end

  devel do
    url "https://cmake.org/files/v3.8/cmake-3.8.0-rc3.tar.gz"
    sha256 "12e86ab188193d8240ef8598fa1f5837a258aa933a5be9a672c5bfe2132a8102"
  end

  option "without-docs", "Don't build man pages"
  option "with-completion", "Install Bash completion (Has potential problems with system bash)"

  depends_on "sphinx-doc" => :build if build.with? "docs"

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew cask install cmake`.

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

    # https://github.com/Homebrew/legacy-homebrew/issues/45989
    if MacOS.version <= :lion
      args << "--no-system-curl"
    else
      args << "--system-curl"
    end

    if build.with? "docs"
      # There is an existing issue around macOS & Python locale setting
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

    elisp.install "Auxiliary/cmake-mode.el"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
