class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/b1/5d/4a5784409ff94900898ff671df2a32bf19469114eb8006286fda3fc7e8d5/doitlive-3.0.3.tar.gz"
  sha256 "d219d4d198acd74fab066e466b2c402a491afdddbeeb40d51b2b9781143321a6"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4bd7e1d2e819fafdf03abe1152eca2ebc21166e322975b89415c23e45c2c07df" => :high_sierra
    sha256 "4bd7e1d2e819fafdf03abe1152eca2ebc21166e322975b89415c23e45c2c07df" => :sierra
    sha256 "4bd7e1d2e819fafdf03abe1152eca2ebc21166e322975b89415c23e45c2c07df" => :el_capitan
  end

  depends_on "python@2"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    system "python", "setup.py", "install", "--prefix=#{libexec}"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/doitlive", "themes", "--preview"
  end
end
