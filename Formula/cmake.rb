class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://cmake.org/files/v3.6/cmake-3.6.2.tar.gz"
  sha256 "189ae32a6ac398bb2f523ae77f70d463a6549926cde1544cd9cc7c6609f8b346"

  head "https://cmake.org/cmake.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8d5820ce83e7e5e7eb1026022fc350b9af2fbc7bdf7f9a3f1be28ca1efee2c4e" => :sierra
    sha256 "1ebc1a16f3f69e116f535f91cdbe6597254da0696d014d6fdcc9564f6af5355e" => :el_capitan
    sha256 "7d9a1c0ff5f53f2b8d36bee900fbb9ea2829285b788f28053a1f455bf97178e7" => :yosemite
  end

  devel do
    url "https://cmake.org/files/v3.7/cmake-3.7.0-rc2.tar.gz"
    sha256 "798e7a48f42a383da767c482810afe9ed6e3f91c99cb27719fd0407b3bf1e96d"
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
