class Sdfcli < Formula
  desc "NetSuite SDF CLI Tool"
  homepage "https://system.netsuite.com/app/help/helpcenter.nl?fid=chapter_4779302061.html"
  url "https://github.com/limebox/sdf/raw/master/Files/brew/sdfcli-17.2.0.tar.gz"
  sha256 "984155c6ed680c581aa85f0e32e43bc7894db5182b3a372267780b5402f441f3"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ba6bbeb1bd44936abd42b0d59d16d37a286471dc40ca6c722f4fa47a8b56a93" => :sierra
    sha256 "6ba6bbeb1bd44936abd42b0d59d16d37a286471dc40ca6c722f4fa47a8b56a93" => :el_capitan
    sha256 "6ba6bbeb1bd44936abd42b0d59d16d37a286471dc40ca6c722f4fa47a8b56a93" => :yosemite
  end

  depends_on "maven" => :build

  def install
    bin.install "sdfcli", "sdfcli-createproject"
    libexec.install "pom.xml", "com.netsuite.ide.core_2017.2.0.jar"
  end

  test do
    system "#{bin}/sdfcli"
  end
end
