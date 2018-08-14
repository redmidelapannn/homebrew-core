class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/6.12.tar.gz"
  sha256 "cde4f61bf541c0df7507c5f138d0068fc643aea19ab3241414db2e659b71ddb3"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1efd2bc22eea44799ec4ad136d47e2b3c461a3e574f541b04856217753a03ac2" => :high_sierra
    sha256 "be66945e549af84b7c64cbc99a8ab8898ea2e1dfdd2851aa8f500dbeab082702" => :sierra
    sha256 "6792e9b698809eb4833e4b978f1dbf1b667b28ca81b2e746ff53e1ed83336421" => :el_capitan
  end

  depends_on "openssl"

  conflicts_with "suite-sparse", :because => "suite-sparse vendors libmongoose.dylib"

  def install
    # No Makefile but is an expectation upstream of binary creation
    # https://github.com/cesanta/mongoose/issues/326
    cd "examples/simplest_web_server" do
      system "make"
      bin.install "simplest_web_server" => "mongoose"
    end

    system ENV.cc, "-dynamiclib", "mongoose.c", "-o", "libmongoose.dylib"
    include.install "mongoose.h"
    lib.install "libmongoose.dylib"
    pkgshare.install "examples", "jni"
    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"hello.html").write <<~EOS
      <!DOCTYPE html>
      <html>
        <head>
          <title>Homebrew</title>
        </head>
        <body>
          <p>Hi!</p>
        </body>
      </html>
    EOS

    begin
      pid = fork { exec "#{bin}/mongoose" }
      sleep 2
      assert_match "Hi!", shell_output("curl http://localhost:8000/hello.html")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
