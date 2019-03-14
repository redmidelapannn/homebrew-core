class AtSpi2Atk < Formula
  desc "Accessibility Toolkit GTK+ module"
  homepage "https://wiki.linuxfoundation.org/accessibility/"
  url "https://download.gnome.org/sources/at-spi2-atk/2.32/at-spi2-atk-2.32.0.tar.xz"
  sha256 "0b51e6d339fa2bcca3a3e3159ccea574c67b107f1ac8b00047fa60e34ce7a45c"

  bottle do
    cellar :any
    sha256 "2b12308bf1c79ca3121ed647d95b1b569058cd69190a8b30bc6cf41c27a3fdb1" => :mojave
    sha256 "27e0de07760620868db8f21cb36035c2532542b371bcad88af9ab672a1fc1786" => :high_sierra
    sha256 "6998270305041c0d27f026b8cc5449ef67ba9eaf5444085ecefd66ec7315728b" => :sierra
  end

  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "at-spi2-core"
  depends_on "atk"

  def install
    ENV.refurbish_args

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end
end
