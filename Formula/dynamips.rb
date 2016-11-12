class Dynamips < Formula
  desc "Cisco 7200/3600/3725/3745/2600/1700 Router Emulator"
  homepage "https://github.com/GNS3/dynamips"
  url "https://github.com/GNS3/dynamips/archive/v0.2.16.tar.gz"
  sha256 "0fcf18d701898a77cb589bd9bad16dde436ac1ccb87516fefe07d09de1a196c0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "af3182ef41b432073770fd468cb45f874948f1b7612b262da3c0d5a0572e608d" => :sierra
    sha256 "ab76935f77bedd37a259904377c193c40053e5764a59eb78104f6576f412ce3a" => :el_capitan
    sha256 "84f87577750e5b69417626f047ede09ed2581ef2eb39d6c25372865a28d42e4f" => :yosemite
  end

  depends_on "libelf"
  depends_on "cmake" => :build

  def install
    ENV.append "CFLAGS", "-I#{Formula["libelf"].include}/libelf"

    arch = Hardware::CPU.is_64_bit? ? "amd64" : "x86"

    ENV.j1
    system "cmake", ".", "-DANY_COMPILER=1", *std_cmake_args
    system "make", "DYNAMIPS_CODE=stable",
                   "DYNAMIPS_ARCH=#{arch}",
                   "install"
  end

  test do
    system "#{bin}/dynamips", "-e"
  end
end
