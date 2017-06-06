class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://cmake.org/files/v3.8/cmake-3.8.2.tar.gz"
  sha256 "da3072794eb4c09f2d782fcee043847b99bb4cf8d4573978d9b2024214d6e92d"
  head "https://cmake.org/cmake.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f61bba99d67bafd4b4ef1fda66c65c93d8be55cde58b5260b8b914b3df5347f9" => :sierra
    sha256 "219cb2afc663145011c198f9f9d918d2811ea36d4f01068bdd0bc9415da7ba8c" => :el_capitan
    sha256 "c58c383dc7d5a3cb19ed6383f78297d7f7363d1dc2e53d5b948f17c42eec8bbf" => :yosemite
  end

  devel do
    url "https://cmake.org/files/v3.9/cmake-3.9.0-rc1.tar.gz"
    sha256 "67112b62e9ecc6e857a94a55a9e64cb779d851db36e4791348938878285474c2"
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
