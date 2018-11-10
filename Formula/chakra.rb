class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.2.tar.gz"
  sha256 "566481c5dd6fbfff80165374ca1ad84f84e24e634596a7dd6f8cceccc86dd47c"
  revision 1

  bottle do
    cellar :any
    sha256 "785a45985174d1e187538639c442b7fa0bd26dea5ead01c1841b3b2e504ff5d1" => :mojave
    sha256 "6d4b74b6343afa5e3d6d94abf6752a977f7cdd7aae1212378991061aeac2e56b" => :high_sierra
    sha256 "fd7b237a91bb7f48aeb3a370ba0242d455611f931ade926d10dc671e0e98e6c4" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "icu4c"

  def install
    args = [
      "--lto-thin",
      "--icu=#{Formula["icu4c"].opt_include}",
      "--extra-defines=U_USING_ICU_NAMESPACE=1", # icu4c 61.1 compatability
      "-j=#{ENV.make_jobs}",
      "-y",
    ]

    # Build dynamically for the shared library
    system "./build.sh", *args
    # Then statically to get a usable binary
    system "./build.sh", "--static", *args

    bin.install "out/Release/ch" => "chakra"
    include.install Dir["out/Release/include/*"]
    lib.install "out/Release/libChakraCore.dylib"
  end

  test do
    (testpath/"test.js").write("print('Hello world!');\n")
    assert_equal "Hello world!", shell_output("#{bin}/chakra test.js").chomp
  end
end
