class Dcadec < Formula
  desc "DTS Coherent Acoustics decoder with support for HD extensions"
  homepage "https://github.com/foo86/dcadec"
  url "https://github.com/foo86/dcadec.git",
    :tag => "v0.2.0",
    :revision => "0e074384c9569e921f8facfe3863912cdb400596"
  head "https://github.com/foo86/dcadec.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "631841efffb0a471ec1c1c2cfa918c8e2de970ae9c255276f7cfda273967fb86" => :sierra
    sha256 "a8183a6430d9b37279752c3f24216ae9e97e58fb42290d04ce96477e643fd1d2" => :el_capitan
    sha256 "3175f8b2f12bd9e7acc39535b9bb819719fbbd9ca94ceec227e88442f2afb2d0" => :yosemite
  end

  resource "sample" do
    url "https://github.com/foo86/dcadec-samples/raw/fa7dcf8c98c6d/xll_71_24_96_768.dtshd"
    sha256 "d2911b34183f7379359cf914ee93228796894e0b0f0055e6ee5baefa4fd6a923"
  end

  def install
    system "make", "all"
    system "make", "check"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    resource("sample").stage do
      system "#{bin}/dcadec", resource("sample").cached_download
    end
  end
end
