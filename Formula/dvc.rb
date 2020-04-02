class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://github.com/iterative/dvc/archive/0.92.0.tar.gz"
  sha256 "660087d41fa6d02bc72a585f3f505a4a559a217fed8be762d220912f3014b3e4"

  bottle do
    cellar :any
    sha256 "3dc6504bad4e6b7594a41f3517fb0f0a9cf4d15b6632a1065a6195a54eb2f605" => :catalina
    sha256 "9c801a448380033b22d49d786226905d780194ee8ca66a4f5b182d64aca003b5" => :mojave
    sha256 "cb216a41d95c0b086d957d354c73d6947f07f44dfdbb22c937c6f82172d722b4" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "apache-arrow"
  depends_on "openssl@1.1"
  # `apache-arrow` currently depends on Python 3.7
  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")

    system libexec/"bin/pip", "install",
      "--no-binary", ":all:",
      # NOTE: we will uninstall Pillow anyway, so there is no need to build it
      # from source.
      "--only-binary", "Pillow",
      "--ignore-installed",
      # NOTE: pyarrow is already installed as a part of apache-arrow package,
      # so we don't need to specify `hdfs` option.
      ".[gs,s3,azure,oss,ssh,gdrive]"

    # NOTE: dvc depends on asciimatics, which depends on Pillow, which
    # uses liblcms2.2.dylib that causes troubles on mojave. See [1]
    # and [2] for more info. As a workaround, we need to simply
    # uninstall Pillow.
    #
    # [1] https://github.com/peterbrittain/asciimatics/issues/95
    # [2] https://github.com/iterative/homebrew-dvc/issues/9
    system libexec/"bin/pip", "uninstall", "-y", "Pillow"
    system libexec/"bin/pip", "uninstall", "-y", "dvc"

    # NOTE: dvc uses this file [1] to know which package it was installed from,
    # so that it is able to provide appropriate instructions for updates.
    # [1] https://github.com/iterative/dvc/blob/0.68.1/dvc/utils/pkg.py
    File.open("dvc/utils/build.py", "w+") { |file| file.write("PKG = \"brew\"") }

    venv.pip_install_and_link buildpath

    bash_completion.install "scripts/completion/dvc.bash" => "dvc"
    zsh_completion.install "scripts/completion/dvc.zsh"
  end

  test do
    system "#{bin}/dvc", "--version"
  end
end
