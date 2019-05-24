class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v20.3.tar.gz"
  sha256 "e8ca2cc5d5ba71e39a702299106dd2a965005703284cec91b3e94691cdce6f65"
  head "https://github.com/cjdelisle/cjdns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7151c2226ea8d26b0f9579ce42755834b32c449f48513402875d5c48534c3bdc" => :mojave
    sha256 "5fd8588941b7b09269e2850664ca61dbe26da584852efb8ffd99d55a546a4500" => :high_sierra
    sha256 "699dd2bd8f451b74e16e9983b227bf92a5c02e2eee7133b3e2e006d193981a64" => :sierra
  end

  depends_on "node" => :build

  def install
    system "./do"
    bin.install "cjdroute"
    (pkgshare/"test").install "build_darwin/test_testcjdroute_c" => "cjdroute_test"
  end

  test do
    system "#{pkgshare}/test/cjdroute_test", "all"
  end
end
