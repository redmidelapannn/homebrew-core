class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://aubio.org/"
  url "https://aubio.org/pub/aubio-0.4.6.tar.bz2"
  sha256 "bdc73be1f007218d3ea6d2a503b38a217815a0e2ccc4ed441f6e850ed5d47cfb"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "625f605d19f1807d0e191f0270834af93a7e93de663b509568ea5d5d2a493186" => :mojave
    sha256 "931b9cfbd59c312ab29cfc59cad6a2e702880439109087fd0d1168b4f6242358" => :sierra
    sha256 "734ca967a8823a2d7ec0150852278b1a679ccf041b37a803c22594badb2b00d5" => :el_capitan
  end

  depends_on :macos => :lion
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "numpy"
  depends_on "python@2"
  depends_on "fftw" => :optional
  depends_on "libav" => :optional

  def install
    # Needed due to issue with recent cland (-fno-fused-madd))
    ENV.refurbish_args

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"

    system "python", *Language::Python.setup_install_args(prefix)
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/aubiocut", "--verbose", "/System/Library/Sounds/Glass.aiff"
    system "#{bin}/aubioonset", "--verbose", "/System/Library/Sounds/Glass.aiff"
  end
end
