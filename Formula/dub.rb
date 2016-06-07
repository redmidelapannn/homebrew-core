class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/about"
  url "https://github.com/dlang/dub.git", :tag => "v0.9.25", :revision => "777e0033e9ca502c134a6cca6b5a06d0e3f78617"
  head "https://github.com/dlang/dub.git", :shallow => false

  bottle do
    revision 1
    sha256 "6829c6eacbb8d5b0792a54ceb984f114230ad862fed617f7ae4f771f3295cc03" => :el_capitan
    sha256 "2c8ad89c7705c726253b8be07b20222bf25bbdd401696a2e4dfe1deb26e550ab" => :yosemite
    sha256 "3ac09adbeba854acbffa9ef9f217756bab16855624fc26ce274740513df78d34" => :mavericks
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.0.0-beta.1.tar.gz"
    sha256 "47191b7299562e0f25bdad28ad8be1d4fe09e6f7c40f50acc78455e3dc28da0c"
    version "1.0.0-beta.1"
  end

  depends_on "pkg-config" => :build
  depends_on "dmd" => :build

  def install
    ENV["GITVER"] = "1.0.0-beta.1" if build.devel?
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    system "#{bin}/dub; true"
  end
end
