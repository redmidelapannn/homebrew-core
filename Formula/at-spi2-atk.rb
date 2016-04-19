class AtSpi2Atk < Formula
  desc "Accessibility Toolkit GTK+ module"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-atk/2.20/at-spi2-atk-2.20.1.tar.xz"
  sha256 "2358a794e918e8f47ce0c7370eee8fc8a6207ff1afe976ec9ff547a03277bf8e"

  bottle do
    cellar :any
    sha256 "81ff169fa5752fb9501f75d2b6a777b7d0eba0ee79987e64d3ba7158d7502ee9" => :el_capitan
    sha256 "cff839b24b9ed63a34b4d0e354805fb6ba1de9416cf80cf11bd2863b9bb00beb" => :yosemite
    sha256 "8dc505cb85cb720ff204d082d4de3229f8917c95a4dfccd7bba78a35b1d1182a" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "at-spi2-core"
  depends_on "atk"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
