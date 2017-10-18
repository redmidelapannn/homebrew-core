require "formula"

class Massren < Formula
  homepage "https://github.com/laurent22/massren"
  url "https://github.com/laurent22/massren/archive/v1.5.1.tar.gz"
  sha256 "21a602a29410e30b1b518356d5707b25b22b9d2578aaf0d0d5ab3de9e0ad225d"
  version "1.5.1"
  bottle do
    cellar :any_skip_relocation
    sha256 "7acb5e3cc42a07f5f25e4df4df66d276ced68fa2f09545d3b422c3c0f7825b35" => :high_sierra
    sha256 "15e0ec3b310b32937d4d51d7c2f8e0336c97e3040a25de44bb8eaffc93bf49db" => :sierra
    sha256 "5611fa6e96b557549c5ac2991c110458ea8c532f99e6fc5b5b856933db499da4" => :el_capitan
  end

  
  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    system 'go', 'get', '-u', 'github.com/jessevdk/go-flags'
    system 'go', 'get', '-u', 'github.com/kr/text'
    system 'go', 'get', '-u', 'github.com/laurent22/go-sqlkv'
    system 'go', 'get', '-u', 'github.com/laurent22/go-trash'
    system 'go', 'get', '-u', 'github.com/mattn/go-sqlite3'
    system 'go', 'get', '-u', 'github.com/nu7hatch/gouuid'
    system 'go', 'build', '-o', 'massren'
    bin.install 'massren'
  end
end
