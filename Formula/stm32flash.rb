class Stm32flash < Formula
  desc "Open source flash program for STM32 using the ST serial bootloader"
  homepage "https://sourceforge.net/projects/stm32flash/"
  url "https://downloads.sourceforge.net/project/stm32flash/stm32flash-0.5.tar.gz"
  sha256 "97aa9422ef02e82f7da9039329e21a437decf972cb3919ad817f70ac9a49e306"

  bottle do
    cellar :any_skip_relocation
    sha256 "2cbbf094a7f2777b674909a5f846bba0cb613a5c2c38e980b67bd769b924e5f5" => :high_sierra
    sha256 "74a92cff8b8099a2b8ee8aa0a2a360639400eb53a24b625c149b052e3f26521e" => :sierra
    sha256 "1e49a9386e4aac0260e3b24872714e59f3984c7f6fb2779e9bd89e0d23bc1655" => :el_capitan
  end

  expected_err = <<~EOF
    Error probing interface "serial_posix"
    Cannot handle device "/dev/tty.XYZ"
    Failed to open port: /dev/tty.XYZ
  EOF
  expected_out = <<~EOF
    stm32flash #{version}

    http://stm32flash.sourceforge.net/


  EOF

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/stm32flash", "-h"

    require "open3"
    Open3.popen3("#{bin}/stm32flash", "-k", "/dev/tty.XYZ") do |_, stdout, stderr, wait_thr|
      assert_equal expected_out, stdout.read
      assert_equal expected_err, stderr.read
      assert_equal 1, wait_thr.value.exitstatus
    end
  end
end
