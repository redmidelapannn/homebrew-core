class Bluetoothconnector < Formula
  desc "Connect and disconnect Bluetooth devices"
  homepage "https://github.com/lapfelix/BluetoothConnector"
  url "https://github.com/lapfelix/BluetoothConnector/archive/1.3.0.tar.gz"
  sha256 "66b94a154e25c867bbdad50e643980a475a63af935900b539e7c48ed0fb1edd7"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b775125ff033627969900d7252af262c01f77c73fb33f1aaf4b71dfc41754cf5" => :catalina
    sha256 "b775125ff033627969900d7252af262c01f77c73fb33f1aaf4b71dfc41754cf5" => :mojave
    sha256 "a87b2de3b8cdde4d8c09f0ce302606283830affcdea8091c3996144fc7492fd0" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc", "-static-stdlib"
    bin.install ".build/release/BluetoothConnector"
  end

  test do
    output = shell_output("#{bin}/BluetoothConnector")
    assert_match "Usage: BluetoothConnector", output
    assert_match "Get the MAC address from the list below", output

    output_fail = shell_output("#{bin}/BluetoothConnector --connect 00-00-00-00-00-00", 252)
    assert_equal "Not paired to device\n", output_fail
  end
end
