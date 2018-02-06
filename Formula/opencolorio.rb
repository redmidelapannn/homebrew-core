class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "http://opencolorio.org/"
  url "https://github.com/imageworks/OpenColorIO/archive/v1.1.0.tar.gz"
  sha256 "228589879e1f11e455a555304007748a8904057088319ebbf172d9384b93c079"
  head "https://github.com/imageworks/OpenColorIO.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8b1adb1425e1b8af5dbad474fd6b2d05aa9b690e861c6c630268ed71499d2653" => :high_sierra
    sha256 "047fdc4339324d0676977624d55603e041ee671e313e55f2de1969dd0a4dba48" => :sierra
    sha256 "8d9a024c674a41bc7ba2644c35f747b675dcbbcf0fd5c7304a8e3dae5195fef2" => :el_capitan
  end

  option "with-test", "Verify the build with its unit tests (~1min)"
  option "with-docs", "Build the documentation"

  deprecated_option "with-tests" => "with-test"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "little-cms2"
  depends_on "python" => :optional

  def install
    args = std_cmake_args
    args << "-DOCIO_BUILD_TESTS=ON" if build.with? "test"
    args << "-DOCIO_BUILD_DOCS=ON" if build.with? "docs"
    args << "-DCMAKE_VERBOSE_MAKEFILE=OFF"

    # Python note:
    # OCIO's PyOpenColorIO.so doubles as a shared library. So it lives in lib, rather
    # than the usual HOMEBREW_PREFIX/lib/python2.7/site-packages per developer choice.
    args << "-DOCIO_BUILD_PYGLUE=OFF" if build.without? "python"

    args << ".."

    mkdir "macbuild" do
      system "cmake", *args
      system "make"
      system "make", "test" if build.with? "test"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      OpenColorIO requires several environment variables to be set.
      You can source the following script in your shell-startup to do that:

          #{HOMEBREW_PREFIX}/share/ocio/setup_ocio.sh

      Alternatively the documentation describes what env-variables need set:

          http://opencolorio.org/installation.html#environment-variables

      You will require a config for OCIO to be useful. Sample configuration files
      and reference images can be found at:

          http://opencolorio.org/downloads.html
    EOS
  end

  test do
    assert_match "validate", shell_output("#{bin}/ociocheck --help", 1)
  end
end
