class Waffle < Formula
  desc "C library for selecting an OpenGL API and window system at runtime"
  homepage "http://www.waffle-gl.org/"
  url "https://gitlab.freedesktop.org/mesa/waffle/-/raw/website/files/release/waffle-1.6.1/waffle-1.6.1.tar.xz"
  sha256 "31565649ff0e2d8dff1b8f7f2264ab7a78452063c7e04adfc4ce03e64b655080"

  bottle do
    cellar :any
    sha256 "9a0f154d64e57f6e0375c35069169414dcc83c4c9167fd29b3811bf4ccbefa08" => :catalina
    sha256 "c372099637e96eb639bb845f39c2cda51af38cbb333e12da4cc42a1c754af9d3" => :mojave
    sha256 "e0cc305c1ac0a2875b44b0669b37d523f3ea3c186fab3ace6fba50fce6ea6055" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :test

  patch do
    url "https://gitlab.freedesktop.org/mesa/waffle/-/commit/82954c7cc3395f556f776b793fbed7e45efcf7a5.diff"
    sha256 "edb68c7f92e099d3702967d08295b02cb4df911aad0e7e076ed11b1b83b50638"
  end

  def install
    args = std_cmake_args + %w[
      -Dwaffle_build_examples=1
      -Dwaffle_build_htmldocs=1
      -Dwaffle_build_manpages=1
    ]

    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    cp_r prefix/"share/doc/waffle1/examples", testpath
    cd "examples"
    system "make", "-f", "Makefile.example"
  end
end
