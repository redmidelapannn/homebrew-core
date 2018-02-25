class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://files.pythonhosted.org/packages/8f/b7/a575a758cf33c8c1ce0ddd642a6c26d94105ca407d68a2074e6731c878b3/wakatime-8.0.3.tar.gz"
  sha256 "bb178937a762a1250dd2e22a62ec28dc7c1ebe2dabcc9bbe05cb781afe86dd47"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "68893123fad87605accafa7c2cff8c776c66fb0b5fadc164f349ca41e4e08747" => :high_sierra
    sha256 "68893123fad87605accafa7c2cff8c776c66fb0b5fadc164f349ca41e4e08747" => :sierra
    sha256 "68893123fad87605accafa7c2cff8c776c66fb0b5fadc164f349ca41e4e08747" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    ENV["PYTHONPATH"] = libexec/"lib/python2.7/site-packages"

    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/wakatime", "--help"
  end
end
