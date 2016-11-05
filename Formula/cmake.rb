class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://cmake.org/files/v3.6/cmake-3.6.3.tar.gz"
  sha256 "7d73ee4fae572eb2d7cd3feb48971aea903bb30a20ea5ae8b4da826d8ccad5fe"

  head "https://cmake.org/cmake.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4069bcd957755868a37d24838492e36ebc598c51d3cf85968e1d9d86cd757666" => :sierra
    sha256 "2a74cbff1495326c60c157b41667658643a51f447999ddae90579532c3b618cd" => :el_capitan
    sha256 "095f250d731454ea87ec58c1b693e5da4a75212e552a9146f01592aa5d022e3e" => :yosemite
  end

  devel do
    url "https://cmake.org/files/v3.7/cmake-3.7.0-rc3.tar.gz"
    sha256 "654a5f0400c88fb07cf7e882e6254d17f248663b51a85ff07d79f7ee7b4795bd"
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
