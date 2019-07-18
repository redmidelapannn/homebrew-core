class Miniconda < Formula
  desc "Continuum Analytics Miniconda"
  homepage "https://conda.io/miniconda.html"
  url "https://repo.anaconda.com/miniconda/Miniconda3-4.6.14-MacOSX-x86_64.sh"

  # Miniconda3 (aka Python 3 envs), exact version not managed by Brew
  version "3"

  sha256 "2ec958508139289df3b5e2c10257311af4f0ebf39242f61d39f11e7fa14ebb40"

  bottle do
    sha256 "ef2c903dbf5c4d63161bd459a06bdf7316ef624116d4bcae56e6510bba95d946" => :mojave
    sha256 "6f71f204bcd1d558aefcdfc74dc8ece1ca63dcea72ab3ec255e5067ffd89fba7" => :high_sierra
    sha256 "98030873b5a43971aef6225e16d4ab57735a9a89e10a312fe2ddf0257c2d07ff" => :sierra
  end

  def install
    system "/bin/bash",
      "Miniconda3-4.6.14-MacOSX-x86_64.sh",
      "-b", "-p", "#{prefix}/opt"

    bin.install_symlink Dir["#{prefix}/opt/condabin/*"]
  end

  test do
    # Make sure our bin runs
    system "#{bin}/conda", "info"

    # Ensure it is our bin
    assert_equal "#{prefix}/opt\n", shell_output("#{bin}/conda info --base")
  end
end
