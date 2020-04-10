class Viewvc < Formula
  desc "Browser interface for CVS and Subversion repositories"
  homepage "http://www.viewvc.org"
  url "https://github.com/viewvc/viewvc/releases/download/1.2.1/viewvc-1.2.1.tar.gz"
  sha256 "afbc2d35fc0469df90f5cc2e855a9e99865ae8c22bf21328cbafcb9578a23e49"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6f7d345a5fd1a2e41d19687028a84b393cd7c1cfe299fe19863579f8b380cfca" => :catalina
    sha256 "74cba4a0bd1e5e8f651abc5322c6a44d5f39bdc0ddb2c602c681e79033b10911" => :mojave
    sha256 "74cba4a0bd1e5e8f651abc5322c6a44d5f39bdc0ddb2c602c681e79033b10911" => :high_sierra
  end

  depends_on "subversion"
  depends_on :macos # Due to Python 2 (https://github.com/viewvc/viewvc/issues/138)

  def install
    system "python", "./viewvc-install", "--prefix=#{libexec}", "--destdir="
    Pathname.glob(libexec/"bin/*") do |f|
      next if f.directory?

      bin.install_symlink f => "viewvc-#{f.basename}"
    end
  end

  test do
    require "net/http"
    require "uri"

    begin
      pid = fork { exec "#{bin}/viewvc-standalone.py", "--port=9000" }
      sleep 2
      uri = URI.parse("http://127.0.0.1:9000/viewvc")
      Net::HTTP.get_response(uri) # First request always returns 400
      assert_equal "200", Net::HTTP.get_response(uri).code
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
