class Saws < Formula
  include Language::Python::Virtualenv

  desc "Supercharged AWS command-line interface (CLI)"
  homepage "https://github.com/donnemartin/saws"
  url "https://github.com/donnemartin/saws/archive/0.4.2.tar.gz"
  sha256 "052b37e73feeea24fb59afcb0bc50119a801533f069535a3dade236517968fe8"
  head "https://github.com/donnemartin/saws.git", :branch => "master"

  bottle do
    cellar :any_skip_relocation
    sha256 "194673f4d7984d6e2b130a2b2d789ece82498a05173601c2dbffc6a77e1f99d6" => :high_sierra
    sha256 "144f6c0732e4d84bc76cf7daacd43d41d30f4b3c08756b2202aa725aed3f04e7" => :sierra
    sha256 "ec7dfe94f05af95f68db20f2eaae57404c471421756c459494a4dd638f8d9b29" => :el_capitan
  end

  # Some AWS APIs require TLS1.2, which system Python doesn't have before High
  # Sierra
  depends_on "python3"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "saws"
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "topics", shell_output("#{bin}/saws --help")
  end
end
