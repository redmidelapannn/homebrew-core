class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://github.com/Gallopsled/pwntools"
  url "https://github.com/Gallopsled/pwntools/archive/3.12.2.tar.gz"
  sha256 "8e048b514ee449b4c76f4eba1b4fcd48fdefd1bf04ae4c62b44e984923d2e979"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2bc7a9cb35f1b49640cd3b0da87c77660c13a3ae526815635c2393e294acd34c" => :mojave
    sha256 "eabb39670be1c8830a099bff41872658a11e702c501528e090770337513bead5" => :high_sierra
    sha256 "fa6fa13ada1778e9a3562b32f0ecbb3bce60d6e6e3c497f88cde23798ae6e814" => :sierra
  end

  depends_on "openssl"
  depends_on "python@2" # does not support Python 3

  conflicts_with "moreutils", :because => "Both install `errno` binaries"

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    assert_equal "686f6d6562726577696e7374616c6c636f6d706c657465",
                 shell_output("#{bin}/hex homebrewinstallcomplete").strip
  end
end
