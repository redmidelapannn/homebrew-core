# jless (Jam Less) is Japan-ized Less.
# jless supports ISO 2022 code extension techniques and Japanese codes.
class Jless < Formula
  desc "File pager supporting ISO2022"
  homepage "http://www.greenwoodsoftware.com/less/"
  url "http://www.greenwoodsoftware.com/less/less-481.tar.gz"
  sha256 "3fa38f2cf5e9e040bb44fffaa6c76a84506e379e47f5a04686ab78102090dda5"
  version_scheme 1

  bottle do
    sha256 "42daba78c301791ff6498aac3caf7f712689cf17cf3ee18036bfe31b0f1a460d" => :sierra
    sha256 "44f18c0fe6441700219442af8c69b06d2432bd37a8d60ebf846b9af0022bacc1" => :el_capitan
    sha256 "97a7f15893b9cb611a4ee57bc62293c97863b1cc1650056cad8f4d99ece17538" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install", "binprefix=j", "manprefix=j"
  end

  def caveats
    "You may need to set the environment variable 'JLESSCHARSET' to japanese-utf8"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jless --version")
  end
end
