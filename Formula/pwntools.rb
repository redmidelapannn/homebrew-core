class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.12.0.tar.gz"
  sha256 "e743daa158a3ac1e958b52e61de47f3db6cec701379712eeda4f4a977ca32309"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0918e744d3f5198f004eb36ba5220d4fb4c6f14b30a24e369cbd6bdeda040649" => :mojave
    sha256 "96855f8c16336622230b7cf4549581f5d0c8d3a1353dc7bf2e4dfca5edc4c71d" => :high_sierra
    sha256 "8061bcf730de7595a2851e5925e941600bf1c820108d054d1f68c3f5db47d474" => :sierra
    sha256 "dbef516203d6e8c0bab59945aba2fa5a147da0c634f2785caac52eba152287a2" => :el_capitan
  end

  depends_on "binutils"
  depends_on "openssl"
  depends_on "python@2"

  if Tab.for_name("moreutils").with?("errno")
    conflicts_with "moreutils", :because => "Both install `errno` binaries"
  end

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
