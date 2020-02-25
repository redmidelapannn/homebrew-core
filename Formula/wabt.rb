class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
    :tag      => "1.0.13",
    :revision => "7c80d05e37dc02870c680869ae3f04ac6d9637ee"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4fd9afc95295324de4c518117fb66bdaa2591849288861e9b2b08c1b0266fec5" => :catalina
    sha256 "16e9543e79e50c773ab39df39be531d2ce9af2d5f88eef2531a1d9eb6e6b1ef2" => :mojave
    sha256 "0ec1dd69acbd936efe4051ba9f3df79452f067d3504f4a5d1915540661819ef6" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTS=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"sample.wast").write("(module (memory 1) (func))")
    system "#{bin}/wat2wasm", testpath/"sample.wast"
  end
end
