class NanopbGenerator < Formula
  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.3.9.tar.gz"
  sha256 "f6fe05441150bf158c2adfec29fa8206785bbb6c3dcd4a3ddbafcf8f9ad9f251"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8b5cea446f0cd60384ec83859495f54631d653b06557af3cc00a416397ca1066" => :high_sierra
    sha256 "8b5cea446f0cd60384ec83859495f54631d653b06557af3cc00a416397ca1066" => :sierra
    sha256 "8b5cea446f0cd60384ec83859495f54631d653b06557af3cc00a416397ca1066" => :el_capitan
  end

  depends_on "python@2"
  depends_on "protobuf"

  def install
    cd "generator" do
      system "make", "-C", "proto"
      inreplace "nanopb_generator.py", %r{^#!/usr/bin/env python$},
                                       "#!/usr/bin/python"
      libexec.install "nanopb_generator.py", "protoc-gen-nanopb", "proto"
      bin.install_symlink libexec/"protoc-gen-nanopb", libexec/"nanopb_generator.py"
    end
  end

  test do
    (testpath/"test.proto").write <<~EOS
      syntax = "proto2";

      message Test {
        required string test_field = 1;
      }
    EOS
    system Formula["protobuf"].bin/"protoc",
      "--proto_path=#{testpath}", "--plugin=#{bin}/protoc-gen-nanopb",
      "--nanopb_out=#{testpath}", testpath/"test.proto"
    system "grep", "test_field", testpath/"test.pb.c"
    system "grep", "test_field", testpath/"test.pb.h"
  end
end
