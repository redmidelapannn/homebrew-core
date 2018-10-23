class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://cmake.org/files/v3.12/cmake-3.12.3.tar.gz"
  sha256 "acbf13af31a741794106b76e5d22448b004a66485fc99f6d7df4d22e99da164a"
  head "https://cmake.org/cmake.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "12ffd6920efe227c07f186ca5b74f2198755aa0c69fa770c883a5e6c7d164581" => :mojave
    sha256 "e49384e71d5d5fe72f7faf8f08a75fc1f4197d157267899c4f6873683b706f45" => :high_sierra
    sha256 "7cff2bb5e2dce768250e03d9f85c41c4e040866f2cbbdc0e7f203c0dd84c9942" => :sierra
  end

  depends_on "sphinx-doc" => :build

  # The completions were removed becuase of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew cask install cmake`.

  needs :cxx11

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    # Avoid the following compiler error:
    # SecKeychain.h:102:46: error: shift expression '(1853123693 << 8)' overflows
    ENV.append_to_cflags "-fpermissive" if MacOS.version <= :lion

    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --sphinx-build=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
      --sphinx-man
      --system-zlib
      --system-bzip2
      --system-curl
    ]

    # There is an existing issue around macOS & Python locale setting
    # See https://bugs.python.org/issue18378#msg215215 for explanation
    ENV["LC_ALL"] = "en_US.UTF-8"

    system "./bootstrap", *args, "--", "-DCMAKE_BUILD_TYPE=Release"
    system "make"
    system "make", "install"

    elisp.install "Auxiliary/cmake-mode.el"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
