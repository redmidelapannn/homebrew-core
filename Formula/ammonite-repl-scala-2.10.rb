class AmmoniteReplScala210 < Formula
  desc "cleanroom re-implementation of the Scala 2.10 REPL"
  homepage "http://www.lihaoyi.com/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/releases/download/0.5.7/ammonite-repl-0.5.7-2.10.5", :using => :nounzip
  version "0.5.7"
  sha256 "9f8e67466f58f6490c2d4b4d0f4ff9ad555ce29909843ba63f5c7533b993642b"

  bottle do
    cellar :any_skip_relocation
    sha256 "71c33523d70b7be84336261573aef29f737b5956f8fa9bd47f09b9e59e342a41" => :el_capitan
    sha256 "b3d4760cb62bdbe4251b9a1928cba244f74ffe8e258a4ce7013eb86a2d499410" => :yosemite
    sha256 "d92fd9bcf8a7f7c3dc47aef357f9130b17a714feb2b40b5518acacdeb743ffc6" => :mavericks
  end

  depends_on :java => "1.7+"

  def install
    bin.install "ammonite-repl-0.5.7-2.10.5" => "amm210"
  end

  test do
    ENV.java_cache
    assert_equal "hello world!", shell_output("#{bin}/amm210 -c 'print(\"hello world!\")'")
  end
end
