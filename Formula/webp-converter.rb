class WebpConverter < Formula
  desc "Converter PNG/JPG to Webp and analytics all changes"
  homepage "https://github.com/Jacksgong/webp-converter"
  url "https://github.com/Jacksgong/webp-converter/archive/v4.0.1.tar.gz"
  sha256 "4be6d5f6cb2e70779c3c6ad114d1d2e30c96d9682d85f3892e444c6cc197b39c"

  bottle do
    cellar :any_skip_relocation
    sha256 "cadff697f1c416b8737537d7a9278a44a39f4c334cab56e221e221a9681ed3ce" => :sierra
    sha256 "8b98bc2d65a41e7f8bd41b60bc0c6cce95ad380df99c7436d9b2df49999fb705" => :el_capitan
    sha256 "8b98bc2d65a41e7f8bd41b60bc0c6cce95ad380df99c7436d9b2df49999fb705" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "webp" => :run

  def install
    ENV["PYTHONPATH"] = libexec/"lib/python2.7/site-packages"

    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/webpc", "--help"
  end
end
