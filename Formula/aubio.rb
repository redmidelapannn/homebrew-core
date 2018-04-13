class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://aubio.org/"
  url "https://aubio.org/pub/aubio-0.4.6.tar.bz2"
  sha256 "bdc73be1f007218d3ea6d2a503b38a217815a0e2ccc4ed441f6e850ed5d47cfb"

  bottle do
    cellar :any
    rebuild 1
    sha256 "58e5e71a952da9e9bc0fabeceab2533e05140c15f1a2d83f0e3597b6c0e109ed" => :high_sierra
    sha256 "7459b35f94fda26bd457310f474c88a547973363a43778a9578835c77ae7bdb3" => :sierra
    sha256 "4d1f1e6bf052412df0e6d969a9bd192336a3e939d4c2166fcd869a3213a3af33" => :el_capitan
  end

  depends_on :macos => :lion
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "numpy"
  depends_on "python@2"
  depends_on "libav" => :optional
  depends_on "libsndfile" => :optional
  depends_on "libsamplerate" => :optional
  depends_on "fftw" => :optional
  depends_on "jack" => :optional

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
