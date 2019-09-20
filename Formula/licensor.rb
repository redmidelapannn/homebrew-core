class Licensor < Formula
  desc "Write a license to standard output given its SPDX ID"
  homepage "https://github.com/raftario/licensor"
  url "https://github.com/raftario/licensor/archive/v1.0.2.tar.gz"
  sha256 "c8531a119fa6d633b7ac569308a074c57fda757113789bd5039b9f1aa2917889"

  bottle do
    cellar :any_skip_relocation
    sha256 "89b4452b074b724f399f9e43b0da5b43bfbe4ab709c655471caab881122cfbbf" => :mojave
    sha256 "0bdc582151de2a3e5d0d684fe0a53635508e348dbd1117616b3fe9ac00261492" => :high_sierra
    sha256 "22a4bb084653a4be72b1e8bb79d8cbb53ac14d8399d33b0bb4a26b136ce128e8" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_match "GNU GENERAL PUBLIC LICENSE", shell_output("#{bin}/licensor GPL-3.0")
  end
end
