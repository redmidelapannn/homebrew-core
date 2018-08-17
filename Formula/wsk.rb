class Wsk < Formula
  desc "OpenWhisk Command-Line Interface (CLI)"
  homepage "http://openwhisk.org"
  url "https://github.com/apache/incubator-openwhisk-cli/archive/0.9.0-incubating.tar.gz"
  sha256 "e2101daae8c4fdd43bb94bc9f8a2a29b74ce0a320b72e162f7f519b4dcbdd9b0"
  depends_on "gradle" => :build

  def install
    system "./gradlew", "compile", "-PnativeCompile"
    bin.install "build/wsk"
  end

  test do
    system "#{bin}/wsk", "--help"
  end
end
