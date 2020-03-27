class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  revision 1
  head "https://gitlab.kitware.com/cmake/cmake.git"

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew cask install cmake`.

  # Allows CMAKE_FIND_FRAMEWORKS to work with CMAKE_FRAMEWORK_PATH, which brew sets.
  # Remove with 3.18.0.
  stable do
    url "https://github.com/Kitware/CMake/releases/download/v3.17.0/cmake-3.17.0.tar.gz"
    sha256 "b74c05b55115eacc4fa2b77a814981dbda05cdc95a53e279fe16b7b272f00847"

    patch do
      url "https://gitlab.kitware.com/cmake/cmake/-/commit/c841d43d70036830c9fe16a6dbf1f28acf49d7e3.diff"
      sha256 "87de737abaf5f8c071abc4a4ae2e9cccced6a9780f4066b32ce08a9bc5d8edd5"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0b7295a22f5721e9e9d873220073f5c15bef180e006b17f920235c93ee05a426" => :catalina
    sha256 "594a6e3f5ad40b405fe211d28d32421f98b9337bd1320e965cd647ae5b62529e" => :mojave
    sha256 "4d7a281fffb74f7e0f022fc8d4f7f5ef9ab41069a940ae02b3a582583e8041d4" => :high_sierra
  end

  depends_on "sphinx-doc" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --sphinx-build=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
      --sphinx-html
      --sphinx-man
      --system-zlib
      --system-bzip2
      --system-curl
    ]

    # There is an existing issue around macOS & Python locale setting
    # See https://bugs.python.org/issue18378#msg215215 for explanation
    ENV["LC_ALL"] = "en_US.UTF-8"

    system "./bootstrap", *args, "--", *std_cmake_args
    system "make"
    system "make", "install"

    elisp.install "Auxiliary/cmake-mode.el"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
