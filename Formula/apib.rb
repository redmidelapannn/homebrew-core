class Apib < Formula
  desc "HTTP performance-testing tool"
  homepage "https://github.com/apigee/apib"
  url "https://github.com/apigee/apib/archive/APIB_1_2.tar.gz"
  sha256 "f2ed580a84ceb456ab3ca6e81c14e61b13c067dc447c65dd8f63dc0e8db15244"
  head "https://github.com/apigee/apib.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a95191cf777c75f2d5f450c08c3d4c6ac8ddd31373fae9140d548389569c7e1c" => :catalina
    sha256 "e99c3424d6100a347f7b81e31d8a9e703e2afe3a7603734b6c82654c90353c8d" => :mojave
    sha256 "cb361028c3a174ccec807aa1dc45241311167412ef5cd179b3020c008ed2eaa3" => :high_sierra
  end

  depends_on "bazel"

  def install
    system "bazel", "build", "-c", "opt", "--copt=-O3", "//apib"
    system "bazel", "build", "-c", "opt", "--copt=-O3", "//apib:apibmon"
    bin.install "bazel-bin/apib/apib", "bazel-bin/apib/apibmon"
  end

  test do
    system "#{bin}/apib", "-c 1", "-d 1", "https://www.google.com"
  end
end
