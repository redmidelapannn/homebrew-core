class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.12.0.tar.gz"
  sha256 "e743daa158a3ac1e958b52e61de47f3db6cec701379712eeda4f4a977ca32309"

  bottle do
    cellar :any
    rebuild 1
    sha256 "618ec3fe1408601799993b927a57370337b19e60a2df9ccf3c7ca975c3609032" => :high_sierra
    sha256 "85449c75277bba46c53039f99932f845af1d2cf0b99f1d07cede3f33ecaf169c" => :sierra
    sha256 "a40949a246bb289e1d954f8fcf8c7453318f0ac33a739b29729d05cd98a5b2b8" => :el_capitan
  end

  depends_on "python@2"
  depends_on "openssl"
  depends_on "binutils" => :recommended

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
