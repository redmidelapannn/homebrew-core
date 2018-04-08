class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/be/1b/c4cc3d72126165873dc1904f6438416b61ab9daa49725c5ce78285ae6f74/twarc-1.4.1.tar.gz"
  sha256 "c7aa7b8e8c8b939aae6014bdbc0f6b5fa4fa54f51872ab6f00b9058322ad8daf"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "04bab4c166f7c2cf2428cbe7b9cf8b5ff59a398690dafff8e5d37cdc4209f473" => :high_sierra
    sha256 "fa749bbf61c58dd1d2a00b257f71b3cef316b06009f2fcc817beee6b845add10" => :sierra
    sha256 "18f4973fd5caa2d54b20b6f118ad7f6a323bce1f724ad98bda333734508b8ba6" => :el_capitan
  end

  depends_on "python@2"

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "twarc"
    venv.pip_install_and_link buildpath
  end

  test do
    assert_equal "usage: twarc [-h] [--log LOG] [--consumer_key CONSUMER_KEY]",
                 shell_output("#{bin}/twarc -h").chomp.split("\n").first
  end
end
