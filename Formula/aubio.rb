class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://aubio.org/"
  url "https://aubio.org/pub/aubio-0.4.9.tar.bz2"
  sha256 "d48282ae4dab83b3dc94c16cf011bcb63835c1c02b515490e1883049c3d1f3da"
  revision 1

  bottle do
    cellar :any
    sha256 "d98de7f88af4e9ab45397561f125125b801e20dbe31bee0e853d32cec012ccc0" => :catalina
    sha256 "ed8695b3ecb2504257d043728a3ee0f2fdfa87c64050cd64572ab00fb31a3b36" => :mojave
    sha256 "7c984192daeeb9aed5601ad651530ba3fc7f521fc90ecfbf2a3ef68975b66a82" => :high_sierra
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "numpy"
  depends_on "python"

  def install
    # Needed due to issue with recent clang (-fno-fused-madd))
    ENV.refurbish_args

    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf", "build"
    system "python3", "./waf", "install"

    system "python3", *Language::Python.setup_install_args(prefix)
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/aubiocut", "--verbose", "/System/Library/Sounds/Glass.aiff"
    system "#{bin}/aubioonset", "--verbose", "/System/Library/Sounds/Glass.aiff"
  end
end
