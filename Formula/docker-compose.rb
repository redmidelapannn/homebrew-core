class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.25.5.tar.gz"
  sha256 "c04d4858b456f5806618fe7a49fadd3f1ccb8f10cf6e499bcf7fdee80a93c21a"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "8b8fda9528565e7ed389826de46237aec1950e5b0a7c44311e3801afe681da68" => :catalina
    sha256 "7b98ac39666ff2649e180b2208353735eac99af16af0f67241735b32bcb22679" => :mojave
    sha256 "e85536c60d7dd1325504d9799c89d693c7803690ea92e7063cbe9ea18cbd8bea" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "python@3.8"

  uses_from_macos "libffi"

  def install
    system "./script/build/write-git-sha" if build.head?
    venv = virtualenv_create(libexec, "python3")
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
