class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "http://flake8.pycqa.org/"
  url "https://gitlab.com/pycqa/flake8/repository/archive.tar.gz?ref=3.5.0"
  sha256 "97ecdc088b9cda5acfaa6f84d9d830711669ad8d106d5c68d5897ece3c5cdfda"

  head "https://gitlab.com/PyCQA/flake8.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f815ad8ca800f0aa395cd92859f0bd37c102acc12ca805ad012ab17a13127cb5" => :high_sierra
    sha256 "95e4c489a30e9175efe804cbae56f9cd3e2457b3607716193f30110a009b83df" => :sierra
    sha256 "b2c2b85ecaf362340e9f09ba88aad9374c5f9850432aa620b04c030902108b44" => :el_capitan
  end

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    xy = Language::Python.major_minor_version "python3"
    system "#{bin}/flake8", "#{libexec}/lib/python#{xy}/site-packages/flake8"
  end
end
