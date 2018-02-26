class Unarj < Formula
  desc "ARJ file archiver"
  homepage "http://www.arjsoftware.com/files.htm"
  url "https://src.fedoraproject.org/repo/pkgs/unarj/unarj-2.65.tar.gz/c6fe45db1741f97155c7def322aa74aa/unarj-2.65.tar.gz"
  sha256 "d7dcc325160af6eb2956f5cb53a002edb2d833e4bb17846669f92ba0ce3f0264"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "dfd50733acfdf16e12fcfe78a822771cc94ac2376ab7624f45955d0534609dc0" => :high_sierra
    sha256 "b1accfbcba5937377aea37727919f07031e8c2243681f2b22ec2c7199dbd91d1" => :sierra
    sha256 "499ad9f34ca324cfd85464fedbc522598a59d8b8825f509ad8692df6513fbdf0" => :el_capitan
  end

  resource "testfile" do
    url "https://s3.amazonaws.com/ARJ/ARJ286.EXE"
    sha256 "e7823fe46fd971fe57e34eef3105fa365ded1cc4cc8295ca3240500f95841c1f"
  end

  def install
    system "make"
    bin.mkdir
    system "make", "install", "INSTALLDIR=#{bin}"
  end

  test do
    # Ensure that you can extract ARJ.EXE from a sample self-extracting file
    resource("testfile").stage do
      system "#{bin}/unarj", "e", "ARJ286.EXE"
      assert_predicate Pathname.pwd/"ARJ.EXE", :exist?
    end
  end
end
