class Ddar < Formula
  desc "De-duplicating archiver"
  homepage "https://github.com/basak/ddar"
  url "https://github.com/basak/ddar/archive/v1.0.tar.gz"
  sha256 "b95a11f73aa872a75a6c2cb29d91b542233afa73a8eb00e8826633b8323c9b22"
  revision 2

  head "https://github.com/basak/ddar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "526c9fba1718751af6fac6544195a5f16e9778a47d4457ed3a1980d2d018e57c" => :el_capitan
    sha256 "cf5e95487a6e21222cc72f5dbf96d6068d84a648041bfb146a83602b2c0c6f20" => :yosemite
    sha256 "6000efa67435efa76947cb425ec570723a57e1814826022fa86d4c72e2d379e6" => :mavericks
  end

  depends_on "xmltoman" => :build
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "protobuf"

  def install
    system "make", "-f", "Makefile.prep", "pydist"
    system "python", "setup.py", "install",
                     "--prefix=#{prefix}",
                     "--single-version-externally-managed",
                     "--record=installed.txt"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    man1.install Dir["*.1"]
  end
end
