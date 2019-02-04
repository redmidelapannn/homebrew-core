class Vapoursynth < Formula
  include Language::Python::Virtualenv

  desc "Video processing framework with simplicity in mind"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R45.1.tar.gz"
  sha256 "4f43e5bb8c4817fdebe572d82febe4abac892918c54e1cb71aa6f6eb3677a877"
  revision 1
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    sha256 "6e97aefefcedd60e3ae1d41b08041c1657c41f9a219071ed1a560792f7342efb" => :mojave
    sha256 "7787949ab9897cb3db5172ce4925d9985022d920d68ce7e27de12f679e6e6d9b" => :high_sierra
    sha256 "b70e2c711b3f8f824390d7aa742601a4a4991c457ec25c340b4764eaba9e77af" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build

  depends_on "ffmpeg"
  depends_on "ffms2"
  depends_on "libass"
  depends_on :macos => :el_capitan # due to zimg dependency
  depends_on "python"
  depends_on "tesseract"
  depends_on "zimg"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/f0/66/6309291b19b498b672817bd237caec787d1b18013ee659f17b1ec5844887/Cython-0.29.tar.gz"
    sha256 "94916d1ede67682638d3cc0feb10648ff14dc51fb7a7f147f4fedce78eaaea97"
  end

  def install
    venv = virtualenv_create(buildpath/"cython", "python3")
    venv.pip_install "Cython"
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--with-cython=#{buildpath}/cython/bin/cython"
    system "make", "install"

    # Add FFMS2 to system-wide autoload search path
    ffms2 = Formula["ffms2"]
    ln_s "#{ffms2.lib}/libffms2.dylib", "#{lib}/vapoursynth/libffms2.dylib"
  end

  test do
    py3 = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{py3}/site-packages"
    system "python3", "-c", "import vapoursynth"
    system bin/"vspipe", "--version"
  end
end
