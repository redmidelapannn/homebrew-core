class WebpConverter < Formula
  desc "Converter PNG/JPG to Webp and analytics all changes"
  homepage "https://jacksgong.com/webp-converter"
  url "https://github.com/Jacksgong/webp-converter/archive/v4.0.0.tar.gz"
  sha256 "481fc8d8a76b810e783dd8febbc4f88e4648c56e81af1cc6bda80d89c7e8f776"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9a7afaf7b493a1fe73ee6bde2c627d43633e7ec8fbc8b90d5e4d240ecdc6e79" => :sierra
    sha256 "af087e2cba2ac0ef644f032d7ac4d141da7049435f796f20faf2f6caf1cd931b" => :el_capitan
    sha256 "af087e2cba2ac0ef644f032d7ac4d141da7049435f796f20faf2f6caf1cd931b" => :yosemite
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
