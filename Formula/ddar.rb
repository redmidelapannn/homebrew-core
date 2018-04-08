class Ddar < Formula
  desc "De-duplicating archiver"
  homepage "https://github.com/basak/ddar"
  url "https://github.com/basak/ddar/archive/v1.0.tar.gz"
  sha256 "b95a11f73aa872a75a6c2cb29d91b542233afa73a8eb00e8826633b8323c9b22"
  revision 5

  head "https://github.com/basak/ddar.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c4c27a468d0b8fc90929ff862f7546557912f70ecbca893e3b0a8f65b120105a" => :high_sierra
    sha256 "71a092e3975fb123bf0f9c4c5d1c4259dc6050ecd8bd854a97671505897590e3" => :sierra
    sha256 "3393cfe7dd6205be0f44302eff1efe4246a851eb8425e8e0fb022a2251c4781c" => :el_capitan
  end

  depends_on "xmltoman" => :build
  depends_on "python@2"
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
