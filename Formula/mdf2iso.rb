class Mdf2iso < Formula
  desc "Tool to convert MDF (Alcohol 120% images) images to ISO images"
  homepage "https://packages.debian.org/sid/mdf2iso"
  url "https://deb.debian.org/debian/pool/main/m/mdf2iso/mdf2iso_0.3.1.orig.tar.gz"
  sha256 "906f0583cb3d36c4d862da23837eebaaaa74033c6b0b6961f2475b946a71feb7"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "d08e30e1d5ff2fd86bfe0db4252eae0f7df14bed81122a74ee383f00412cd7e6" => :mojave
    sha256 "40ed01e97edd92b1bcdd37df1620051ad52de21b01d90b3bee16dd50c2b7c06d" => :high_sierra
    sha256 "b451a7957d4cd3a21d97d7b407be75b105c588556dc4e49dfa24ec86e4f3f3ec" => :sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdf2iso --help")
  end
end
