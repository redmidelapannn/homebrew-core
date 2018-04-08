class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.20.1.tar.gz"
  sha256 "49a0e2c7a49a5b161c3e74dfdae8173e18174b1fcd8d7675c556a988f0ed95d1"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1c17a08c68c31862949c8b917cf129b5928d865c2b443174c104d3b4571b33a0" => :high_sierra
    sha256 "ec9171cd48195d20afec33d584697b27f99b0f3707c1c532a53c328550809574" => :sierra
    sha256 "f4e5451f27f442296be005194d3849981223c11bf21b47307e50fc6c1401c230" => :el_capitan
  end

  depends_on "python@2"
  depends_on "libyaml"

  # It's possible that the user wants to manually install Docker and Machine,
  # for example, they want to compile Docker manually
  depends_on "docker" => :recommended
  depends_on "docker-machine" => :recommended

  def install
    system "./script/build/write-git-sha" if build.head?
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "docker-compose"
    venv.pip_install_and_link buildpath

    bash_completion.install "contrib/completion/bash/docker-compose"
    zsh_completion.install "contrib/completion/zsh/_docker-compose"
  end

  test do
    system bin/"docker-compose", "--help"
  end
end
