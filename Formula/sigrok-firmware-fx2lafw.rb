class SigrokFirmwareFx2lafw < Formula
  desc "Open-source firmware for Cypress FX2 chips"
  homepage "https://sigrok.org/wiki/Fx2lafw"
  url "https://sigrok.org/download/source/sigrok-firmware-fx2lafw/sigrok-firmware-fx2lafw-0.1.7.tar.gz"
  sha256 "a3f440d6a852a46e2c5d199fc1c8e4dacd006bc04e0d5576298ee55d056ace3b"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5f0aa05285d94c47f39aded747533a341bd13dfd3d7a99fce8c7e4eaa629515" => :catalina
    sha256 "a5f0aa05285d94c47f39aded747533a341bd13dfd3d7a99fce8c7e4eaa629515" => :mojave
    sha256 "a5f0aa05285d94c47f39aded747533a341bd13dfd3d7a99fce8c7e4eaa629515" => :high_sierra
  end

  depends_on "make" => :build
  depends_on "sdcc" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "13", shell_output("ls -1 #{share}/sigrok-firmware/ | grep -v ^l | wc -l").strip
  end
end
