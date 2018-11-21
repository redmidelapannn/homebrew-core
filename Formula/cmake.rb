class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://cmake.org/files/v3.13/cmake-3.13.0.tar.gz"
  sha256 "4058b2f1a53c026564e8936698d56c3b352d90df067b195cb749a97a3d273c90"
  head "https://cmake.org/cmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c18a0b90928c44b274e14ef6fd806a880f1be4f90f2341baf508ff953d5963f" => :mojave
    sha256 "f59de9296200ca3dbadd33a54c2968599fde4ca9c1d2500f5b7bf1f0999c3f4e" => :high_sierra
    sha256 "438e4e74d8ea9e50a383eb5d139c6d8f7efad66d3e62e271707187f40f3f713b" => :sierra
  end

  depends_on "sphinx-doc" => :build

  # The completions were removed because of problems with system bash

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
