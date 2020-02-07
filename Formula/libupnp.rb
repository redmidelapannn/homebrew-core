class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pupnp/pupnp/libupnp-1.10.1/libupnp-1.10.1.tar.bz2"
  sha256 "b97dad43f5fbb1dad34384389ab038823862348e9e5f6d649d845d512165ed92"

  bottle do
    cellar :any
    sha256 "4975e881b4ef713414e8b227439f8ab37eda6b4db1da4abc6f0eb249d1cb865c" => :catalina
    sha256 "3330274143c9d9a0104a4897ede4fdfb5dbaa177f0a10205051d00829cf2b79b" => :mojave
    sha256 "ee4f2c782ee77e1c1d13e405e2110938c7393a52b1cb40211fa7bd46d745108c" => :high_sierra
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ipv6
    ]

    system "./configure", *args
    system "make", "install"
  end
end
