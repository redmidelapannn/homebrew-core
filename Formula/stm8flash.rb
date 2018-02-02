class Stm8flash < Formula
  desc "Program your stm8 devices with SWIM/stlinkv(1,2)"
  homepage "https://github.com/vdudouyt/stm8flash"
  url "https://github.com/vdudouyt/stm8flash.git", :revision => "6007cb7062bb86d4c17c79174ee177e80939f602"
  version "20170616-1.1"
  bottle do
    cellar :any
    sha256 "fc77d293d880bd48d80f34886e45b9add500cc3c3c135ba1cc453dd21cffdd44" => :high_sierra
    sha256 "08d74e78cbc93fbb59a18dfa566e7c5d99de2d0d9af36368bd855d3464a0a4d8" => :sierra
    sha256 "6603adb79f8923b3ded433a33da746a0dbd806084aad969ac1ea9fc3e09822eb" => :el_capitan
  end

  depends_on "libusb"
  depends_on "pkg-config" => :build
  def install
    system "make"
    mkdir_p bin
    cp buildpath/"stm8flash", bin
  end
  test do
    system "#{bin}/stm8flash", "-V"
  end
end
