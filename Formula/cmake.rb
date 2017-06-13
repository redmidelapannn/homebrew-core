class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://cmake.org/files/v3.8/cmake-3.8.2.tar.gz"
  sha256 "da3072794eb4c09f2d782fcee043847b99bb4cf8d4573978d9b2024214d6e92d"
  head "https://cmake.org/cmake.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f4a0aeec7b64d7b51a135df1348cab9f1510810e29359e94e8c96f9aa37b3746" => :sierra
    sha256 "f33f3d02e6d53287a957e96d191e196829540fdca71f6e7b5da4abac83d10d8e" => :el_capitan
    sha256 "541451c925949305e49fcaf2cf216a996c255342e4c4fc50e505e3ed2e527e06" => :yosemite
  end

  devel do
    url "https://cmake.org/files/v3.9/cmake-3.9.0-rc3.tar.gz"
    sha256 "83706bdcbebc6fdf1cf309dda8fec2bb4259dbae8aa5e98150c72ce4f590f1d2"
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
      --system-curl
    ]

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
