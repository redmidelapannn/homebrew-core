class Dte < Formula
  desc "Small and configurable console text editor"
  homepage "https://github.com/craigbarnes/dte"
  url "https://github.com/craigbarnes/dte/releases/download/v1.8.2/dte-1.8.2.tar.gz"
  sha256 "778786c0b2588f0d9a651ebfde939885a5579745dae8f5d9adc480f4895d6c04"

  bottle do
    cellar :any_skip_relocation
    sha256 "10fc49724ed832b0578402c16b6d5bc94d8a5cc64246cc5c0bc044964c4db355" => :mojave
    sha256 "4a7476c1d5886c27ec70cf2b707a947f79d8190b49517e005f0a877249f621fb" => :high_sierra
    sha256 "1c739ee7056168972230475ade723045aefe8eacead35430159438aacce71803" => :sierra
  end

  def install
    system "make", "-j#{ENV.make_jobs}"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    assert_equal "20", shell_output("#{bin}/dte -b compiler/gcc | wc -l").strip
  end
end
