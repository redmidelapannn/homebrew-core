class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.11.0.tar.gz"
  sha256 "b86f9bed835153d1ce1839d03836aa062802ac9f5495942027030407ef1b798a"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "5b64310ae56f7163be64eaf266d92b9e2b901948af327e59603925ead3ad5c0a" => :high_sierra
    sha256 "42ded2566e301195135b0ee2309fe4ed261dbed8b8896082d07988b9c9d58e78" => :sierra
    sha256 "c701a111fd8e2ef0f4e23a9d9fcc2759bc7d6588783de2f3df06e3a76f0e1fbf" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard
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
