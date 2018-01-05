
class Duviz < Formula
  include Language::Python::Virtualenv

  desc "Command-line disk space usage visualization utility"
  homepage "https://github.com/soxofaan/duviz"
  url "https://github.com/soxofaan/duviz/archive/1.1.0.tar.gz"
  sha256 "72ecd1ffc5bcc0900bd2b5c5708cf1eb6de2c1ba512b1dfb80a802e9754dea32"

  bottle do
    cellar :any_skip_relocation
    sha256 "805588dcebb17d182604119878947f0727391f4465384eed0e930777b961fe6f" => :high_sierra
    sha256 "ee20dbb134271cddbe77b68769993dfe900ed31c11f5b8372419d437680ac386" => :sierra
    sha256 "6417ec67cbc9681ee37b4bfd9c05bee0b8314be8888d221278eb27e613ed5b1d" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir "work"
    (testpath/"work/helloworld.txt").write("hello world")
    assert_equal "__________\n[  work  ]\n[___2____]", shell_output("#{bin}/duviz --no-progress -i --width=10 work").chomp
  end
end
