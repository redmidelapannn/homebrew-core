class Unarj < Formula
  desc "ARJ file archiver"
  homepage "http://www.arjsoftware.com/files.htm"
  url "https://src.fedoraproject.org/repo/pkgs/unarj/unarj-2.65.tar.gz/c6fe45db1741f97155c7def322aa74aa/unarj-2.65.tar.gz"
  sha256 "d7dcc325160af6eb2956f5cb53a002edb2d833e4bb17846669f92ba0ce3f0264"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ff911b9cbc0ba22e4e3c744d2674c7da0e9fd9d7d984d3836b7a99bed1a9473b" => :mojave
    sha256 "0c9f8b6fe968581db26fd4b1dfb82175f0dcd4d9820fa92239ac73c9ce24ff0a" => :high_sierra
    sha256 "ff18537bd61ac20709e675bae5b89a14ddc92b9916735955f3296e2806ab5818" => :sierra
  end

  resource "testfile" do
    url "https://s3.amazonaws.com/ARJ/ARJ286.EXE"
    mirror "https://www.sac.sk/download/pack/arj286.exe"
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
