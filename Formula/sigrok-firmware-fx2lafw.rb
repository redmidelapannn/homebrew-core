class SigrokFirmwareFx2lafw < Formula
  desc "Open-source firmware for Cypress FX2 chips"
  homepage "https://sigrok.org/wiki/Fx2lafw"
  url "https://sigrok.org/download/source/sigrok-firmware-fx2lafw/sigrok-firmware-fx2lafw-0.1.7.tar.gz"
  sha256 "a3f440d6a852a46e2c5d199fc1c8e4dacd006bc04e0d5576298ee55d056ace3b"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0de4c591b415c12d70832d8011535306818106d77dcfd1ac926116244cd2541" => :catalina
    sha256 "b0de4c591b415c12d70832d8011535306818106d77dcfd1ac926116244cd2541" => :mojave
    sha256 "b0de4c591b415c12d70832d8011535306818106d77dcfd1ac926116244cd2541" => :high_sierra
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
