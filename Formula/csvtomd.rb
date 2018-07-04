class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https://github.com/mplewis/csvtomd"
  url "https://files.pythonhosted.org/packages/2f/41/289bedde7fb32d817d5802eff68b99546842cb34df840665ec39b363f258/csvtomd-0.2.1.tar.gz"
  sha256 "d9fdf166c3c299ad5800b3cb1661f223b98237f38f22e9d253d45d321f70ec72"
  revision 4

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b6e8eb2266a080fdc4a7bec46c24af74dac1d1f9b0b1ad22a4b6eb797184ff1d" => :high_sierra
    sha256 "6a08840b74e568180a08c8ffeff849a63fd1245636f54a473432ef879fff159c" => :sierra
    sha256 "5676eaf5502c692da6ae9cc0e10d86c6ee1b689fb3b55b923acd64456da9b00c" => :el_capitan
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.csv").write <<~EOS
      column 1,column 2
      hello,world
    EOS
    markdown = <<~EOS.strip
      column 1  |  column 2
      ----------|----------
      hello     |  world
    EOS
    assert_equal markdown, shell_output("#{bin}/csvtomd test.csv").strip
  end
end
