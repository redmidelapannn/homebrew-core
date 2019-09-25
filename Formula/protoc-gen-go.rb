class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/golang/protobuf"
  url "https://github.com/golang/protobuf/archive/v1.3.2.tar.gz"
  sha256 "c9cda622857a17cf0877c5ba76688a931883e505f40744c9495638b6e3da1f65"
  head "https://github.com/golang/protobuf.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "592f1b4493b5a6a9b82fe766448ee40c8b8ca49ff4ada87f0795a24354e027d8" => :mojave
    sha256 "fc457414f5244e5c75856010923b2be311f1dc4f906ef1c40eae3669e3810f65" => :high_sierra
    sha256 "0e4b4af8ab3e2550e07be327bfba6539bd36d8740a79bff83570a99ba507535c" => :sierra
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/golang/protobuf").install buildpath.children
    system "go", "install", "github.com/golang/protobuf/protoc-gen-go"
    bin.install buildpath/"bin/protoc-gen-go"
  end

  test do
    protofile = testpath/"proto3.proto"
    protofile.write <<~EOS
      syntax = "proto3";
      package proto3;
      message Request {
        string name = 1;
        repeated int64 key = 2;
      }
    EOS
    system "protoc", "--go_out=.", "proto3.proto"
    assert_predicate testpath/"proto3.pb.go", :exist?
    refute_predicate (testpath/"proto3.pb.go").size, :zero?
  end
end
