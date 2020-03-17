class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20200225.tgz"
  sha256 "f6493e4a643a4ba9c3b2424b7f491186efc2ba5fd93d2285d65b7c5aca676cf9"

  bottle do
    cellar :any
    sha256 "5716a80e73a3d25e11141cb13126a3e36b373fc2a744bb66082fb5b89e629957" => :catalina
    sha256 "9a82dc21efebb0bafb6313e4f29f6aaa3a142347fd5e5e7ba7350433e2531722" => :mojave
    sha256 "f3a120a52ef9e9399395c6a4a91098b73ea8e4a8889e21b4646283011534fea8" => :high_sierra
    sha256 "47d1adc4fcbf5218c074d27a8db604a4f2ab4e5f3d5f14e023497e9cad5b49b4" => :sierra
  end

  def install
    system "make"
    bin.install "hdhomerun_config"
    lib.install "libhdhomerun.dylib"
    include.install Dir["hdhomerun*.h"]
  end

  test do
    # Devices may be found or not found, with differing return codes
    discover = pipe_output("#{bin}/hdhomerun_config discover")
    assert_match /no devices found|hdhomerun device|found at/, discover
  end
end
