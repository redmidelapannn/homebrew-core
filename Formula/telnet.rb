class Telnet < Formula
  desc "User interface to the TELNET protocol (built from macOS Sierra sources)"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/remote_cmds/remote_cmds-54.50.1.tar.gz"
  sha256 "156ddec946c81af1cbbad5cc6e601135245f7300d134a239cda45ff5efd75930"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "4c8d89033c31344542011981b495e3360a84c2b50b823e1c13dee0fb95c1cff8" => :high_sierra
    sha256 "8552228cc667d0366890470510cffc4806c3af69ae72454ea31123d3bb7b3c0d" => :sierra
    sha256 "1cc5487aa536698de041bb0efb68e2da9fe47027cb9ad785a7cf35aebd524524" => :el_capitan
  end

  keg_only :provided_pre_high_sierra

  depends_on :xcode => :build

  conflicts_with "inetutils", :because => "both install 'telnet' binaries"

  resource "libtelnet" do
    url "https://opensource.apple.com/tarballs/libtelnet/libtelnet-13.tar.gz"
    sha256 "e7d203083c2d9fa363da4cc4b7377d4a18f8a6f569b9bcf58f97255941a2ebd1"
  end

  def install
    resource("libtelnet").stage do
      ENV["SDKROOT"] = MacOS.sdk_path
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
      xcodebuild "SYMROOT=build"

      libtelnet_dst = buildpath/"telnet.tproj/build/Products"
      libtelnet_dst.install "build/Release/libtelnet.a"
      libtelnet_dst.install "build/Release/usr/local/include/libtelnet/"
    end

    system "make",
      "-C", "telnet.tproj",
      "OBJROOT=build/Intermediates",
      "SYMROOT=build/Products",
      "DSTROOT=build/Archive",
      "CFLAGS=$(CC_Flags) -isystembuild/Products/",
      "LDFLAGS=$(LD_Flags) -Lbuild/Products/",
      "install"

    bin.install "telnet.tproj/build/Archive/usr/bin/telnet"
    man.install "telnet.tproj/build/Archive/usr/share/man/man1/"
  end

  test do
    output = shell_output("#{bin}/telnet 94.142.241.111 666", 1)
    assert_match "Connected to towel.blinkenlights.nl.", output
  end
end
